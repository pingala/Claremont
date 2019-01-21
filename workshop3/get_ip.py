import requests
import json

def get_tor_session():
    session = requests.session()
    session.headers = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'
    }

    # We must use socks5 protocol to use Tor
    session.proxies = {
        'http':  'socks5://127.0.0.1:9050',
        'https': 'socks5://127.0.0.1:9050'
    }
    return session

print("--- Regular")
print(json.loads(requests.get("http://ipinfo.io/json").text))
print("--- Tor")
print(json.loads(get_tor_session().get("http://ipinfo.io/json").text))