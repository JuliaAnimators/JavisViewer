module JavisViewer

using Cairo
using Gtk
using GtkReactive
using Javis

include("javis_viewer.jl")

export stream
export setup_stream, cancel_stream

function stream(
    video::Video;
    framerate = 30,
    pathname = "javis_$(randstring(7)).gif",
    liveview = false,
    streamconfig::Union{StreamConfig,Nothing} = nothing,
    tempdirectory = "",
    ffmpeg_loglevel = "panic",
    rescale_factor = 1.0,
    postprocess_frames_flow = identity,
    postprocess_frame = Javis.default_postprocess,
)

    v = render(
        video::Video;
        framerate = framerate,
        pathname = pathname,
        liveview = liveview,
        tempdirectory = tempdirectory,
        ffmpeg_loglevel = ffmpeg_loglevel,
        rescale_factor = rescale_factor,
        postprocess_frames_flow = postprocess_frames_flow,
        postprocess_frame = postprocess_frame,
    )

    # check if livestream is used and livestream if that's the case
    if liveview
        _javis_viewer(v...)
        return "Live Preview Started"
    else
        _livestream(streamconfig, framerate, video.width, video.height, pathname)
    end
end

end
