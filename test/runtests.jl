using Animations
using GtkReactive
using Gtk: get_gtk_property, visible
using Images
import Interact
import Interact: @map, Widget, Widgets, @layout!, hbox, vbox
using Javis
import Latexify: latexify
using LaTeXStrings
using ReferenceTests
using Test
using VideoIO
using JavisViewer

function ground(args...)
    background("white")
    sethue("black")
end

@testset "Javis Viewer" begin
    astar(args...; do_action = :stroke) = star(O, 50, 5, 0.5, 0, do_action)
    acirc(args...; do_action = :stroke) = circle(Point(100, 100), 50, do_action)

    vid = Video(500, 500)
    back = Background(1:100, ground)
    star_obj = Object(1:100, astar)
    act!(star_obj, Action(morph_to(acirc; do_action = :fill)))

    l1 = @JLayer 20:60 100 100 Point(0, 0) begin
        obj = Object((args...) -> circle(O, 25, :fill))
        act!(obj, Action(1:20, appear(:fade)))
    end

    liveview(vid; pathname = "")

    action_list = [back, star_obj]

    viewer_win, frame_dims, r_slide, tbox, canvas, actions, total_frames, video =
        JavisViewer._javis_viewer(vid, 100, action_list, false)
    visible(viewer_win, false)

    @test get_gtk_property(viewer_win, :title, String) == "Javis Viewer"

    JavisViewer._increment(
        video,
        [r_slide, tbox],
        actions,
        frame_dims,
        canvas,
        total_frames,
    )
    sleep(0.1)
    curr_frame = Reactive.value(r_slide)
    second_frame = Javis.get_javis_frame(video, actions, curr_frame, layers = [l1])
    @test Reactive.value(r_slide) == 2

    JavisViewer._decrement(
        video,
        [r_slide, tbox],
        actions,
        frame_dims,
        canvas,
        total_frames,
    )
    sleep(0.1)
    curr_frame = Reactive.value(r_slide)
    first_frame = Javis.get_javis_frame(video, actions, curr_frame, layers = [l1])
    @test Reactive.value(r_slide) == 1

    @test first_frame != second_frame

    JavisViewer._decrement(
        video,
        [r_slide, tbox],
        actions,
        frame_dims,
        canvas,
        total_frames,
    )
    sleep(0.1)
    curr_frame = Reactive.value(r_slide)
    last_frame = Javis.get_javis_frame(video, actions, curr_frame, layers = [l1])
    @test curr_frame == total_frames

    JavisViewer._increment(
        video,
        [r_slide, tbox],
        actions,
        frame_dims,
        canvas,
        total_frames,
    )
    sleep(0.1)
    curr_frame = Reactive.value(r_slide)
    first_frame = Javis.get_javis_frame(video, actions, curr_frame, layers = [l1])
    @test curr_frame == 1

    @test last_frame != first_frame
end
