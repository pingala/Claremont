import requests
import json
import sys

target_dir = sys.argv[1]

def get_tor_session():
    session = requests.session()
    session.headers = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'
    }
    session.proxies = {
        'http':  'socks5://127.0.0.1:9050',
        'https': 'socks5://127.0.0.1:9050'
    }
    return session


output = {
    "normal": json.loads(requests.get("http://ip-api.com/json").text),
    "tor": json.loads(get_tor_session().get("http://ip-api.com/json").text)
}

with open("./%s/output.json" % (target_dir), "w") as fout:
    fout.write(json.dumps(output, indent=2))
