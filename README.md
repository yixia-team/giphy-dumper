# Giphy dumper

Check [GiphyAPI](https://github.com/Giphy/GiphyAPI) for more details.

### Install

```bash
git clone git@github.com:yixia-team/giphy-dumper.git
cd ./giphy-dumper
bundle install
chmod +x main.rb
```

### Usage

> Remember to change `api_key` with your own!

```bash
./main.rb cat dog anime # Multiple keywords are treated seprately. If you want to combine them as a single keyword:
./main.rb cat+dog # This should work.
./main.rb anime:100 # Default fetch count is 25. You can specify it like this.
```

GIFs are stored in `./incoming/KEYWORD/`.
