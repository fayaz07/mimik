# Troubleshooting

#### Rebuilding better-sqlite3

This is a pain, `better-sqlite3` is a native module and has to be rebuilt.
If you just run `npm run rebuild`, it will throw some weird `node-gyp` issues, make sure to install `python-setuptools`

For macos:

```bash
brew install python-setuptools
```
