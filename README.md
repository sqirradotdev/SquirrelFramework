# SquirrelFramework

SquirrelFramework is a base framework used for developing Godot Engine games. Think of it as a foundation, a set of tools and systems to quickly start your new game project.

# Features

- A special type of scenes called "States" for game state management.
- ResourceQueue and Util helper singletons
- Dedicated debug canvas separate from game viewport

...and more to come!

# Getting Started

## Method 1: For new projects

Clone the [example project](https://github.com/gedehari/SFExampleProject) and make sure to initialize the submodules.

```
git clone --recurse-submodules https://github.com/gedehari/SFExampleProject <projectname>
cd <projectname>
```

or

```
git clone https://github.com/gedehari/SFExampleProject <projectname>
cd <projectname>
git submodule update --init --recursive
```

## Method 2: For existing projects

If you are using git in your project, add this repo as a submodule.

```
git submodule add https://github.com/gedehari/SquirrelFramework addons/SquirrelFramework
```

However, if you are not using git, you can always download or clone this repo and copying it inside the `addons` folder in your project.

# License

This repo is licensed under the MIT License. See [LICENSE.md](LICENSE.md) for more information.
