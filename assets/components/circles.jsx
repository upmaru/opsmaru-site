import React, { useRef } from 'react'
import { motion, useScroll } from 'framer-motion'

export function Circles({ container }) {
  const ref = useRef(container)

  const { scrollYProgress } = useScroll({
    target: ref,
    offset: ["start end", "end end"]
  })

  return (
    <>
      <motion.svg width={2560} height={2560} strokeLinecap="round" className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 stroke-[3px] stroke-slate-100 fill-slate-800 opacity-10 transform-gpu" viewBox="0 0 1000 1000" xmlns="http://www.w3.org/2000/svg">
        <motion.circle cx="500" cy="500" r="480"
          pathLength="1" strokeLinecap="round" style={{ pathLength: scrollYProgress  }}
          />
      </motion.svg>
      <motion.svg width={1582} height={1582} strokeLinecap="round" className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2  stroke-[3px] stroke-slate-100 fill-slate-800 opacity-10 rotate-90 transform-gpu" viewBox="0 0 1000 1000" xmlns="http://www.w3.org/2000/svg">
        <motion.circle cx="500" cy="500" r="480" 
          pathLength="1" style={{ pathLength: scrollYProgress }}
          />
      </motion.svg>
      <motion.svg width={977} height={977} strokeLinecap="round" className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2  stroke-[3x] stroke-slate-100 fill-slate-800 opacity-10 rotate-0 transform-gpu" viewBox="0 0 1000 1000" xmlns="http://www.w3.org/2000/svg">
        <motion.circle cx="500" cy="500" r="480" 
          pathLength="1" strokeLinecap="round" style={{ pathLength: scrollYProgress }}
          />
      </motion.svg>
      <motion.svg width={603} height={603} strokeLinecap="round" className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2  stroke-[3px] stroke-slate-100 fill-slate-800 opacity-10 rotate-45 transform-gpu" viewBox="0 0 1000 1000" xmlns="http://www.w3.org/2000/svg">
        <motion.circle cx="500" cy="500" r="480" 
          pathLength="1" style={{ pathLength: scrollYProgress }}
          />
      </motion.svg>
      <motion.svg width={373} height={373} className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2  stroke-[3px] stroke-slate-100 fill-slate-800 opacity-10 rotate-90 transform-gpu" viewBox="0 0 1000 1000" xmlns="http://www.w3.org/2000/svg">
        <motion.circle cx="500" cy="500" r="480" 
          pathLength="1" style={{ pathLength: scrollYProgress }}
          />
      </motion.svg>
    </>
  )
}