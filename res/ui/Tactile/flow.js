/**
 * flow.js
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * A succession of scenes and steps stringed together for the app.
 */


/* jshint undef: true, unused: true */
/* globals Qt, qsTr, new_scene, new_step, initialise_steps, run_steps, repeat_step, skip_step, Tactile, Colours, app, display, hw, progress */


Qt.include('scenes.js');
Qt.include('flow_lib.js');
Qt.include('colour_palette.js');

/**
 * Ideally the syntax:
 *     .import 'Animation/animations/computer.js' as ASCII_ANMIATIONS
 *  would be used, but for now we will have to settle for naming the variables
 *  in the included files
 */
Qt.include('Animation/animations/rabbit.js');
Qt.include('Animation/animations/computer.js');
Qt.include('Animation/animations/keyboard.js');
Qt.include('Animation/animations/boom.js');


function create_steps() {
    var permitted_retries = 2,
        explosion_animation = {
            frames: boom_animation,
            columns: 30,
            rows: 18,
            fps: 20
        },
        saved_progress = progress.get_checkpoint(),
        username = saved_progress.username || "";

    /* purely to follow if and where we restore Tactile from a premature exit */
    console.log("flow saved progress=" + saved_progress.checkpoint_id);
    console.log("flow username=" + username);

    app.hide_cursor();

    /**
     * Start Screen
     */
    new_scene(Tactile.TextNext.TextNextScene);

    new_step(function(scene){
        scene.text = "How Touch Works";
        scene.next_button_text = "Let's Go";
    }, Tactile.TextNext.signals.next);

    /**
     * Greetings
     */

    new_scene(Tactile.Terminal.Terminal);

    new_step(function(scene) {
        scene.echo_msg(qsTr(
            "Hello...<br>"
        ));
        scene.timer.sleep(2000);
    }, Tactile.Sleep.signals.wait_over);

    /**
     * Touch screen interactive animation
     */

    new_scene(Tactile.Touch.TouchScreenScene);

    new_step(function(scene) {
        scene.echo_msg(qsTr(
            "Your screen is filled with invisible wires<br><br>" +
            "<font color='%1'>Touch the screen</font> to see them"
        ).arg(Colours.yellow));
    }, Tactile.Touch.TouchScreenScene.signals.touched);

    new_step(function(scene) {
        scene.clear_msgs();
        scene.echo_msg(qsTr(
            "These wires can feel the <font color='%1'>electric charge</font> " +
            "in your fingers...<br><br>" +
            "Now try swiping with all ten!"
        ).arg(Colours.yellow));
        scene.timer.sleep(20 * 1000);  // ms
    }, Tactile.Sleep.signals.wait_over);

    new_step(function(scene) {
        scene.prompt({prompt_marker: qsTr("Press [ENTER] to continue")});
    }, Tactile.Audio.VisualiseMicrophone.signals.response);

    // Creation of the TouchScreenScene causes the padding to be modified, even
    // if the scene itself is skipped. Prevent this by restoring regardless.
    new_step(function(scene) {
        scene.restorePadding();
    });

    /**
     * Finalising
     */

    new_scene(Tactile.Terminal.Terminal);

    new_step(function(scene) {
        progress.clear_checkpoint();
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
