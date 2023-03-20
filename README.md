# SquirrelFramework

SquirrelFramework is a foundation for developing Godot Engine games. It's a set of tools and systems to quickstart your new game project. 🚀

**IMPORTANT: This addon only supports Godot 3.5 only and does not support Godot 4!**

# Features

- Game state management with a special State scene type
- Helper singletons (ResourceQueue, Util, etc)
- Dedicated debug canvas separate from the game viewport

...and more to come! Roadmap coming soon.

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

However, if you are not using git, you can always download or clone this repo and copying it to the `addons` folder inside your project.

# License

This repo is licensed under the MIT License. See [LICENSE.md](LICENSE.md) for more information.
