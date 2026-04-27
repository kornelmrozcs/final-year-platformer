## Development Notes

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
