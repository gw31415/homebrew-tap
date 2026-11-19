"""Wait for an Apple notarization submission on Linux, so a macOS runner is not held.

Polls the Notary API (App Store Connect API key, ES256 JWT signed by openssl)
until SUBMISSION_ID leaves "In Progress". On any status but Accepted, prints
Apple's log and fails. Env: SUBMISSION_ID, NOTARY_KEY_FILE (.p8),
NOTARY_KEY_ID, NOTARY_ISSUER_ID, NOTARY_WAIT_HOURS (default 5.5).
"""
import base64, json, os, subprocess, sys, time, urllib.request

API = "https://appstoreconnect.apple.com/notary/v2/submissions/"


def b64(data):
    return base64.urlsafe_b64encode(data).rstrip(b"=").decode()


def raw_signature(der):
    # openssl writes ECDSA-Sig-Value ::= SEQUENCE { r INTEGER, s INTEGER }; JWS wants r || s.
    assert der[0] == 0x30
    i = 2 if der[1] < 0x80 else 2 + (der[1] & 0x7F)
    out = b""
    for _ in range(2):
        assert der[i] == 0x02
        n = der[i + 1]
        out += der[i + 2 : i + 2 + n].lstrip(b"\0").rjust(32, b"\0")
        i += 2 + n
    return out


def token():
    now = int(time.time())
    head = b64(json.dumps({"alg": "ES256", "kid": os.environ["NOTARY_KEY_ID"], "typ": "JWT"}).encode())
    body = b64(json.dumps({"iss": os.environ["NOTARY_ISSUER_ID"], "iat": now, "exp": now + 600, "aud": "appstoreconnect-v1"}).encode())
    der = subprocess.run(["openssl", "dgst", "-sha256", "-sign", os.environ["NOTARY_KEY_FILE"]],
                         input=f"{head}.{body}".encode(), capture_output=True, check=True).stdout
    return f"{head}.{body}.{b64(raw_signature(der))}"


def get(path):
    req = urllib.request.Request(API + path, headers={"Authorization": "Bearer " + token()})
    with urllib.request.urlopen(req, timeout=60) as res:
        return json.load(res)


if __name__ == "__main__":
    sid = os.environ["SUBMISSION_ID"]
    deadline = time.time() + float(os.environ.get("NOTARY_WAIT_HOURS", "5.5")) * 3600
    errors = 0
    while True:
        try:
            status = get(sid)["data"]["attributes"]["status"]
            errors = 0
        except Exception as e:  # network or API hiccup; give up after ten in a row
            errors += 1
            print(f"poll failed ({errors}): {e}", flush=True)
            if errors >= 10:
                sys.exit("::error::Cannot read the notarization status")
            status = "In Progress"
        print(time.strftime("%H:%M:%S"), status, flush=True)
        if status != "In Progress":
            break
        if time.time() > deadline:
            sys.exit(f"::error::Notarization {sid} is still in progress")
        time.sleep(30)
    if status != "Accepted":
        try:
            url = get(sid + "/logs")["data"]["attributes"]["developerLogUrl"]
            with urllib.request.urlopen(url, timeout=60) as res:
                print(res.read().decode())
        except Exception as e:
            print("could not fetch the log:", e)
        sys.exit(f"::error::Notarization {sid} ended with status {status}")
