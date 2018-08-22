/**
 * flow_lib.js
 *
 * Copyright (C) 2018 Kano Computing Ltd.
 * License: http://www.gnu.org/licenses/gpl-2.0.txt GNU GPLv2
 *
 * Library to facilitate the description of the flow as a sequence
 * of scenes and steps.
 */


/* jshint undef: true, unused: false */
/* globals Qt, TerminalSettings, progress */


var step_queue = [
    ],
    step_counter = 0,
    scene_id = 0,
    skip_current_scene = false,
    saved_progress,
    running_steps,
    current_scene,
    scene_loader,
    proceed_cb;


function start_here() {
    step_queue = [];
}


function load_scene(scene_name) {
    var scene;

    scene_loader.setSource(scene_name, {
        color: 'black'
    });
    scene = scene_loader.item;

    // Expose the background to the scene object
    Object.defineProperty(
        scene,
        'background',
        {
            enumerable: false,
            configurable: false,
            writable: false,
            value: scene_loader.background
        }
    );

    Object.defineProperty(
        scene,
        'settings',
        {
            enumerable: false,
            configurable: false,
            writable: true,
            value: TerminalSettings
        }
    );

    var timer = Qt.createComponent('sleep.qml')
                .createObject(scene);
    Object.defineProperty(
        scene,
        'timer',
        {
            enumerable: false,
            configurable: false,
            writable: false,
            value: timer
        }
    );

    return scene;
}


function new_step(fn, signal) {
    var step = {
        id: step_counter++,
        fn: fn,
        signal: signal
    };

    if (skip_current_scene) {
        return;
    }

    step_queue.push(step);

    return step;
}


function repeat_step(step) {
    var current_step = running_steps[0],
        len = step_queue.length,
        idx,
        step_data;

    // Find current step
    for (idx = 0; idx < len; idx++) {
        if (step_queue[idx].id === current_step.id) {
            break;
        }
    }

    // Step backwards until we reach the step
    do {
        idx--;
        step_data = step_queue[idx];
        running_steps.unshift(step_data);
    } while (step_data.id !== step.id && idx >= 0);
}


function new_scene(scene) {
    if (skip_current_scene = (--saved_progress.checkpoint_id > 0)) {
        // This scene is skipped so the scene ID won't be incremented
        scene_id++;
    }

    new_step(function() {
        progress.mark_checkpoint(++scene_id);
        current_scene = load_scene(scene.name);
    });

    return {
        is_skipped: skip_current_scene
    };
}


function get_prop(obj, i) {
    return obj[i];
}


function run_steps(args) {
    var first,
        fn,
        signal;

    if (running_steps === undefined) {
        running_steps = step_queue.slice(0);
    }

    first = running_steps[0];
    running_steps.splice(0, 1);

    if (first === undefined) {
        return;
    }

    fn = first.fn;
    signal = first.signal;

    if (signal === undefined) {
        fn(current_scene, args);
        run_steps();
    } else {
        var next_signal = [current_scene].concat(signal.split('.'))
                          .reduce(get_prop);
        proceed_cb = function (signal_args) {
            next_signal.disconnect(proceed_cb);
            run_steps(signal_args);
        };

        next_signal.connect(proceed_cb);
        fn(current_scene, args);
    }
}


/**
 * Skips the current scene
 *
 * FIXME: Currently fails to properly skip if the current step is
 *        one which doesn't proceed when a signal is received, i.e.
 *        one of the form `new_step(function() {});` with the signal
 *        not provided.
 */
function skip_step() {
    proceed_cb();
}


function initialise_steps(loader) {
    // TODO: Decide whether we need this savefile checkpoint.
    // saved_progress = progress.get_checkpoint() || {};
    console.log("Warning: Scene progress checkpoint disabled in flow_lib.js");
    saved_progress = {}

    if (saved_progress.checkpoint_id === "") {
        saved_progress.checkpoint_id = 0;
    }

    scene_loader = loader;
}
