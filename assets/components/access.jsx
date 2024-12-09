import React, { useState, useEffect } from 'react'
import { motion, useAnimate } from 'framer-motion'

const container = {
  hidden: { opacity: 0 },
  show: {
    opacity: 1, 
    transition: {
      staggerChildren: 0.1
    }
  }
}

const character = {
  hidden: { opacity: 0 },
  show: { opacity: 1 }
}

const loggedInText = `
Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-47-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

Expanded Security Maintenance for Applications is not enabled.

62 updates can be applied immediately.
To see these additional updates run: apt list --upgradable

10 additional security updates can be applied with ESM Apps.
Learn more about enabling ESM Apps service at https://ubuntu.com/esm
`

function Window(props) {
  return (
    <svg
    width={props.width}
    height={props.height}
    viewBox="0 0 883 606"
    xmlns="http://www.w3.org/2000/svg"
    xmlnsXlink="http://www.w3.org/1999/xlink"
    xmlSpace="preserve"
    xmlns:serif="http://www.serif.com/"
    style={{
      fillRule: "evenodd",
      clipRule: "evenodd",
      strokeLinecap: "round",
      strokeLinejoin: "round",
      strokeMiterlimit: 1.5,
    }}
    {...props}
  >
      <path
        d="M882.375,13.949l0,578.102c0,7.492 -6.082,13.574 -13.574,13.574l-854.852,0c-7.492,0 -13.574,-6.082 -13.574,-13.574l-0,-578.102c-0,-7.492 6.082,-13.574 13.574,-13.574l854.852,0c7.492,0 13.574,6.082 13.574,13.574Z"
        style={{
          fill: "#020617",
          fillOpacity: 0.36,
          stroke: "#fff",
          strokeOpacity: 0.14,
          strokeWidth: "0.75px",
        }}
      />
      <path
        d="M0.375,571.875l882,0"
        style={{
          fill: "none",
          stroke: "#fff",
          strokeOpacity: 0.2,
          strokeWidth: "0.75px",
        }}
      />
    </svg>
  )
}

export function SSHAccess() {
  const [isLoggedIn, setIsLoggedIn] = useState(false)
  const [scope, animate] = useAnimate()

  useEffect(() => {
    if (!isLoggedIn) {
      animate(scope.current, { opacity: 0 })
    }

    if (isLoggedIn) {
      animate(scope.current, { opacity: 1 })
    }
  }, [isLoggedIn])

  return (
    <div>
      <Window width={800} height={600} className="absolute left-1/2 -translate-x-1/2 -bottom-8"/>
      <motion.div className="absolute left-10 bottom-0 mb-0.5 text-xs font-mono" onAnimationStart={() => setIsLoggedIn(false)} onAnimationComplete={() => setIsLoggedIn(true) } variants={container} initial="hidden" whileInView="show">
        {'ssh ubuntu@your-bastion-address'.split('').map((char, index) => <motion.span variants={character} key={`${char}-${index}`} className='text-slate-400'>{char}</motion.span>)}
      </motion.div>
      <motion.div ref={scope} className="absolute left-10 bottom-0 mb-2 text-xs text-slate-500 font-mono" initial={{ opacity: 0 }}>
        {loggedInText.split("\n\n").map((line, index) => 
          <div className="my-6" key={index}>{line.split("\n").map((l, idx) => <p key={`line-${idx}`}>{l}</p>)}</div>
        )}
      </motion.div>
    </div>
  )
}