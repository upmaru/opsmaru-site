import React from 'react'

import { clsx } from 'clsx'
import { motion } from 'framer-motion'

const logoSettings = [
  {
    left: 330, 
    top: 130, 
    hover: { x: 6, y: 1, rotate: 5, delay: 0.38 }
  },
  {
    left: 285, 
    top: 20, 
    hover: { x: 4, y: -5, rotate: 6, delay: 0.3 }
  },
  {
    left: 255,
    top: 210,
    hover: { x: 3, y: 5, rotate: 7, delay: 0.2 }
  },
  {
    left: 144, 
    top: 40, 
    hover: { x: -2, y: -5, rotate: -6, delay: 0.15 }
  },
  {
    left: 36, 
    top: 56, 
    hover: { x: -4, y: -5, rotate: -6, delay: 0.35 }
  },
  {
    left: 96, 
    top: 176, 
    hover: { x: -3, y: 5, rotate: 3, delay: 0.15 }
  },
]

function Circle({ size, delay, opacity }) {
  return (
    <motion.div
      variants={{
        idle: { width: `${size}px`, height: `${size}px` },
        active: {
          width: [`${size}px`, `${size + 10}px`, `${size}px`],
          height: [`${size}px`, `${size + 10}px`, `${size}px`],
          transition: {
            duration: 0.75,
            repeat: Infinity,
            repeatDelay: 1.25,
            ease: 'easeInOut',
            delay,
          },
        },
      }}
      style={{ '--opacity': opacity }}
      className={clsx(
        'absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 rounded-full',
        'bg-[radial-gradient(circle,transparent_25%,color-mix(in_srgb,_theme(colors.indigo.500)_var(--opacity),transparent)_100%)]',
        'ring-1 ring-inset ring-indigo-600/[8%]',
      )}
    />
  )
}

function Circles() {
  return (
    <div className="absolute inset-0">
      <Circle size={528} opacity="5%" delay={0.45} />
      <Circle size={400} opacity="10%" delay={0.3} />
      <Circle size={272} opacity="10%" delay={0.15} />
      <Circle size={144} opacity="10%" delay={0} />
      <div className="absolute inset-0 bg-gradient-to-t from-white to-35%" />
    </div>
  )
}

function MainLogo() {
  return (
    <div className="absolute left-44 top-32 flex size-16 items-center justify-center rounded-full bg-white shadow ring-1 ring-black/5">
      <img src={"/site/images/logo-color.svg"} className="h-9" />
    </div>
  )
}

function Logo({ src, left, top, hover }) {
  return (
    <motion.span
      variants={{
        idle: { x: 0, y: 0, rotate: 0 },
        active: {
          x: [0, hover.x, 0],
          y: [0, hover.y, 0],
          rotate: [0, hover.rotate, 0],
          transition: {
            duration: 0.75,
            repeat: Infinity,
            repeatDelay: 1.25,
            ease: 'easeInOut',
            delay: hover.delay,
          },
        },
      }}
      alt=""
      style={{ left, top }}
      className="absolute size-16 flex rounded-full align-middle items-center justify-center bg-white shadow ring-1 ring-black/5"
    >
      <img src={src} className="h-9" />
    </motion.span>
  )
}

export function Technologies({ technologies }) {
  return (
    <motion.div aria-hidden="true" 
      initial="idle"
      whileHover="active"
      variants={{ idle: {}, active: {} }} 
      className="relative h-full overflow-hidden">
      <Circles />
      <div className="absolute left-1/2 h-full w-[26rem] -translate-x-1/2">
        <MainLogo />
        {technologies.map((technology, i) => {
          const setting = logoSettings[i]

          return (
            <Logo key={`technology-${i}`} src={technology.logo.url} left={setting.left} top={setting.top} hover={setting.hover} />
          )
        })}
      </div>
    </motion.div>
  )
}