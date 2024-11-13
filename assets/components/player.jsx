import React from 'react'
import MuxPlayer from "@mux/mux-player-react"

export function Player({ movie }) {
  return (
    <MuxPlayer playbackId={movie.video.playback_id} accentColor="#67e8f9" metadata={{ video_title: movie.title }}/>
  )
}