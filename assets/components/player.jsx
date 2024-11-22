import React from 'react'
import MuxPlayer from "@mux/mux-player-react"

export function Player({ video, title }) {
  return (
    <MuxPlayer playbackId={video.playback_id} accentColor="#a78bfa" metadata={{ video_title: title }} />
  )
}