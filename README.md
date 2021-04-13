# Makeconf-gen

> Just an attemp to autogen a make.conf for gentoo and based distributions

## Usage

Generating a make.conf file

```bash
./src/gen.sh
```

You can now update things like `VIDEO_CARDS` and `INPUT_DEVICES` with any undetected material

## Note for bbswitch users

We have some issues with bbswitch, if you have an optimus GPU, you may "optirun" some software to make sure nvidia gpu are detected. See [#1](https://github.com/Woomy4680-exe/makeconf-gen/issues/1)

