/**
 * flow.js
 *
 * Copyright (C) 2018-2019 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * A succession of scenes and steps stringed together for the app.
 */


/* jshint undef: true, unused: true */
/* globals Qt, qsTr, new_scene, new_step, initialise_steps, run_steps, repeat_step, skip_step, Tactile, Colours, app, display, hw, progress, touch, tracker */


Qt.include('scenes.js');
Qt.include('flow_lib.js');
Qt.include('colour_palette.js');


function create_steps() {
    var saved_progress = progress.get_checkpoint(),
        touch_supported = touch.is_touch_supported();

    /* purely to follow if and where we restore Tactile from a premature exit */
    console.log("flow saved progress = " + saved_progress.checkpoint_id);

    if (touch_supported) {
        app.hide_cursor();
    }

    /**
     * Start the app
     */

    new_scene(Tactile.Start.StartScene);
    new_step(function(scene) {
        scene.text = qsTr("How Touch Works");
        scene.next_button_text = qsTr("Let's Go");

        if (!touch_supported) {
            scene.note_text = qsTr("Optimised for touch");
        }
    }, Tactile.Start.StartScene.signals.done);

    /**
     * Reveal the wires
     */

    new_scene(Tactile.Wires.RevealTheWires);
    new_step(function(scene) {
        scene.bg_image = 'Wires/touchscreen.png';
        scene.instructions = qsTr(
            "<p>There are amazing things hidden inside your screen...\n</p>" +
            "\n" +
            "<b>Swipe to see them</b>"
        );
        // Prevent accidental tapping from previous scene skipping instructions
        scene.timer.sleep(2000);
    }, Tactile.Sleep.signals.wait_over);
    new_step(function(scene) {
        scene.enabled = true;
    }, Tactile.Wires.RevealTheWires.signals.revealed);
    new_step(function(scene) {
        scene.prompt(qsTr(
            "Your screen is filled with invisible wires made " +
            "of Indium Oxide. Ready to see what they do?"
        ), {
            button_text: qsTr('Next'),
            bg_enabled: true
        });
    }, Tactile.Wires.RevealTheWires.signals.done);

    /**
     * Touch a wire
     */

    new_scene(Tactile.Wires.TouchAWire);
    new_step(function(scene) {
        scene.prompt(
            qsTr("Each wire is filled with electric charges."
            ), {
                bg_enabled: true
            });
        scene.timer.sleep(10000);
    }, Tactile.Sleep.signals.wait_over);
    new_step(function(scene) {
        scene.prompt(qsTr(
            "But so is your finger!\n" +
            "<b>Touch</b> the wire to see what happens..."
        ), {
            bg_enabled: true
        });
        scene.timer.sleep(10000);
    }, Tactile.Sleep.signals.wait_over);
    new_step(function(scene) {
    }, Tactile.Wires.TouchAWire.signals.touched);
    new_step(function(scene) {
        scene.prompt(qsTr(
            "When you touch the screen the wires can detect the electric " +
            "charge in your finger"
        ), {
            bg_enabled: true
        });
        scene.timer.sleep(10000);
    }, Tactile.Sleep.signals.wait_over);
    new_step(function(scene) {
        scene.prompt('');
        scene.timer.sleep(4000);
    }, Tactile.Sleep.signals.wait_over);
    new_step(function(scene) {
        scene.prompt('', {
            button_text: qsTr('Next'),
        });
    }, Tactile.Wires.TouchAWire.signals.done);

    /**
     * Touch a grid
     */

    new_scene(Tactile.Wires.TouchAGrid);
    new_step(function(scene) {
        scene.prompt(qsTr(
            "Each wire keeps an eye out for your finger\n" +
            "<b>Touch</b> the screen again"
        ), {
            bg_enabled: true
        });
        scene.timer.sleep(10000);
    }, Tactile.Sleep.signals.wait_over);
    new_step(function(scene) {
        // pass
    }, Tactile.Wires.TouchAGrid.signals.touch);
    new_step(function(scene) {
        scene.prompt(qsTr(
            "Together the wires can figure out the exact points that " +
            "you're touching"
        ), {
            bg_enabled: true
        });
        scene.timer.sleep(10000);
    }, Tactile.Sleep.signals.wait_over);
    new_step(function(scene) {
        scene.prompt(qsTr(
            "Try touching multiple places\n" +
            "Your screen can detect up to 10 touch points!"
        ), {
            bg_enabled: true
        });
        scene.timer.sleep(10000);
    }, Tactile.Sleep.signals.wait_over);
    new_step(function(scene) {
        scene.prompt(qsTr(
            "Next, the wires get together and send messages to your " +
            "computer's brain..."
        ), {
            button_text: qsTr('Next'),
            bg_enabled: true
        });
    }, Tactile.Wires.TouchAGrid.signals.done);

    /**
     * Touch points
     */

    new_scene(Tactile.Wires.TouchPoints);
    new_step(function(scene) {
        scene.prompt(qsTr(
            "<b>Touch</b> with 5 fingers to see the secret messages!"
        ), {
            bg_enabled: true
        });
        // Give a couple of seconds to read the instructions
        scene.timer.sleep(10000);
    }, Tactile.Sleep.signals.wait_over);
    new_step(function(scene) {
        // After the wait, dismiss on press
    }, Tactile.Wires.TouchPoints.signals.pressed);
    new_step(function(scene) {
        scene.prompt();
        scene.quiz({
            question: qsTr(
                'What do those x and y numbers mean?\n' +
                'Try to figure it out, then tap the correct answer:'
            ),
            responses: [
                qsTr('How fast your finger is moving'),
                qsTr('Where your finger is on the screen'),
                qsTr('How much electricity is in your finger')
            ],
            answer: 1,
            bg_enabled: true
        });
    }, Tactile.Wires.TouchPoints.signals.correct_response);
    new_step(function(scene) {
        scene.timer.sleep(1500);
    }, Tactile.Sleep.signals.wait_over);

    /**
     * Reveal the colors
     */

    new_scene(Tactile.Wires.RevealTheWires);
    new_step(function(scene) {
        scene.bg_image = 'Pixels/rainbow.png';
        scene.instructions = qsTr(
            "Did you see those points of light?\n" +
            "\n" +
            "<b>Swipe</b> to chase them into your screen"
        );
        // Prevent accidental tapping from previous scene skipping instructions
        scene.timer.sleep(2000);
    }, Tactile.Sleep.signals.wait_over);
    new_step(function(scene) {
        scene.enabled = true;
    }, Tactile.Wires.RevealTheWires.signals.revealed);

    /**
     * Guess the pixel
     */

    new_scene(Tactile.Pixels.GuessThePixel);
    new_step(function(scene) {
        scene.prompt(qsTr(
            "Beneath the wires, your screen is full of 1 million colorful " +
            "little lights... called pixels"
        ), {
            bg_enabled: true,
            button_text: qsTr('Next')
        });
    }, Tactile.Pixels.GuessThePixel.signals.next);
    new_step(function(scene) {
        scene.fade_color();
        // Left eye
        scene.prompt(qsTr(
            "Let's bring the two layers of the screen together - touch " +
            "and pixels!\n" +
            "\n" +
            "Can you find pixel 300, 300?"
        ), {
            bg_enabled: true
        });
        scene.reset_target(300, 300, true);
    }, Tactile.Pixels.GuessThePixel.signals.target_hit);
    new_step(function(scene) {
        scene.prompt(qsTr(
            "Do you see that?\n" +
            "That's a pixel!"
        ), {
            bg_enabled: true
        });
        scene.timer.sleep(10000);
    }, Tactile.Sleep.signals.wait_over);
    new_step(function(scene) {
        // Right eye
        scene.prompt(qsTr(
            "Every pixel has an address.\n" +
            "Can you touch pixel 500, 300?"
        ), {
            bg_enabled: true
        });
        scene.reset_target(500, 300);
    }, Tactile.Pixels.GuessThePixel.signals.target_hit);
    new_step(function(scene) {
        // Center mouth
        scene.prompt(qsTr(
            "Can you touch pixel 400, 500?"
        ), {
            bg_enabled: true
        });
        scene.reset_target(400, 500);
    }, Tactile.Pixels.GuessThePixel.signals.target_hit);
    new_step(function(scene) {
        // Center-right mouth
        scene.prompt(qsTr(
            "Can you touch pixel 500, 485?"
        ), {
            bg_enabled: true
        });
        scene.reset_target(475, 485);
    }, Tactile.Pixels.GuessThePixel.signals.target_hit);
    new_step(function(scene) {
        // Right mouth
        scene.prompt(qsTr(
            "Can you touch pixel 550, 450?"
        ), {
            bg_enabled: true
        });
        scene.reset_target(550, 450);
    }, Tactile.Pixels.GuessThePixel.signals.target_hit);
    new_step(function(scene) {
        // Center-left mouth
        scene.prompt(qsTr(
            "Can you touch pixel 320, 485?"
        ), {
            bg_enabled: true
        });
        scene.reset_target(320, 485);
    }, Tactile.Pixels.GuessThePixel.signals.target_hit);
    new_step(function(scene) {
        // Left mouth
        scene.prompt(qsTr(
            "Can you touch pixel 250, 450?"
        ), {
            bg_enabled: true
        });
        scene.reset_target(250, 450);
    }, Tactile.Pixels.GuessThePixel.signals.target_hit);
    new_step(function(scene) {
        scene.prompt('');
        scene.timer.sleep(5000);
    }, Tactile.Sleep.signals.wait_over);
    new_step(function(scene) {
        scene.transition();
    }, Tactile.Pixels.GuessThePixel.signals.done);

    /**
     * Subpixel simulator
     */

    new_scene(Tactile.Pixels.SubpixelSimulator);
    new_step(function(scene) {
        scene.prompt(qsTr(
            "This is what a pixel looks like up close!\n" +
            "It's made up of little red, green and blue lights"
        ), {
            bg_enabled: true
        });
        scene.timer.sleep(10000);
    }, Tactile.Sleep.signals.wait_over);
    new_step(function(scene) {
        scene.prompt(
            qsTr("<b>Swipe up and down</b> to change the color"), {
                bg_enabled: true
            });
        scene.timer.sleep(10000);
    }, Tactile.Sleep.signals.wait_over);
    new_step(function(scene) {
        scene.prompt(
            qsTr(
                "The red, green and blue lights can work together to make " +
                "any color!"
            ), {
                bg_enabled: true
            }
        );
        scene.timer.sleep(10000);
    }, Tactile.Sleep.signals.wait_over);
    new_step(function(scene) {
        scene.set_target(0.95, 0.4, 0.1);
        scene.prompt(
            qsTr("Can you try to make orange?"), {
                bg_enabled: true
            });
    }, Tactile.Pixels.SubpixelSimulator.signals.color_matched);
    new_step(function(scene) {
        scene.prompt(
            qsTr("Nice work!"), {
                bg_enabled: true,
                button_text: qsTr('Next')
            }
        );
    }, Tactile.Pixels.SubpixelSimulator.signals.done);

    /**
     * Pixel divider
     */

    new_scene(Tactile.Pixels.PixelDivider);
    new_step(function(scene) {
        scene.prompt(qsTr(
            "Pixels can work together to make images...\n" +
            "<b>Tap</b> the screen to see this happen"
        ), {
            bg_enabled: true
        });
        scene.timer.sleep(2000);
    }, Tactile.Sleep.signals.wait_over);
    new_step(function(scene) {
        // pass
    }, Tactile.Pixels.PixelDivider.signals.touch);
    new_step(function(scene) {
        scene.prompt(qsTr("Keep tapping!"), {
            bg_enabled: true
        });
    }, Tactile.Pixels.PixelDivider.signals.touch);
    new_step(function(scene) {
        scene.prompt(qsTr("Keep tapping!"), {
            bg_enabled: true
        });
    }, Tactile.Pixels.PixelDivider.signals.touch);
    new_step(function(scene) {
        scene.prompt('');
    }, Tactile.Pixels.PixelDivider.signals.done);
    new_step(function(scene) {
        scene.prompt(qsTr(
            'The pixels join to form an image.'
        ), {
            bg_enabled: true
        });
        scene.timer.sleep(8000);
    }, Tactile.Sleep.signals.wait_over);

    /**
     * End screen
     */

    new_scene(Tactile.Start.StartScene);
    new_step(function(scene) {
        scene.text = qsTr(
            "That's how your touch screen works.\n" +
            "Now go play with it."
        );
        scene.next_button_text = qsTr("Try more");
    }, Tactile.Start.StartScene.signals.done);

    /**
     * Finalising
     */

    new_scene(Tactile.Terminal.Terminal);

    new_step(function(scene) {
        progress.clear_checkpoint();
        tracker.track_action('tactile-complete');
    });

    new_step(function() {
        Qt.quit();
    });
}

function run(loader) {
    initialise_steps(loader);
    create_steps();
    run_steps();
}
