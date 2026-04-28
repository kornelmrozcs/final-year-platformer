# Development Notes

## First Step

I added the first test scene and a basic tilemap level. The idea for this test level is that it should eventually require all planned movement features to complete it.

So far, I added:

- basic player movement
- jump
- tilemap collision
- player collision
- camera follow
- first test level layout
- placeholder/free sprites
- edited player colour
- extra wall slide frame in the player sprite sheet for later use

After testing, the movement already feels quite responsive in the air, and I like that the character feels fast. However, it is still very rough. The jump currently has to be pressed almost perfectly when the player touches the ground, because there is no jump buffer yet. There is also no coyote time, so falling from platforms feels unforgiving and harder to control. The jump height also feels too high at the moment.

Next movement improvements:

- add jump buffer
- add coyote time
- tune jump height
- improve falling control
- start preparing the controller for a simple state machine

## Added Basic Player State Machine

After the first movement test, I started restructuring the player controller into a simple state machine. The reason for this is that movement is the most important part of this project, so I want the controller to stay readable as more movement features are added.

The current state machine is still basic. It only handles:

- Idle
- Run
- Jump
- Fall

The player controller still keeps the shared movement values and helper functions, such as speed, gravity, jump force, horizontal movement and input checks. The state machine decides which movement state is currently active and calls the correct logic from that state.
