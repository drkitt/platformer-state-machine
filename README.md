# Platformer state machine

This repository is an implementation of the [state pattern](https://gameprogrammingpatterns.com/state.html), used for a platformer character in the Godot engine.

Each state is a separate node, and there are also utility classes for behaviour shared between states. It was built with extensibility in mind; it should be easy to build on the existing structure to create state machines that are more complex or even of a different type (such as a hierarchical state machine).

## Example project

The project included in this repository serves as an example for the state machine implementation. You can download it to run and jump around with a character that was programmed using the state machine!

By the way, the character in the example uses the cutout animation style, so this project also kinda-sorta doubles as an example for using the AnimationPlayer node with several animation tracks.

## How do I run the example?

Just clone the repository, [download Godot](https://godotengine.org) if you haven't already, open up the `project.godot` file, and you're good to go!

## Authors and Acknowledgements

- Made by Alex Kitt
