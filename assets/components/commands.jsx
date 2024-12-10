import React, { useState, useEffect } from 'react'
import { createRoot } from "react-dom/client";
import { motion, useAnimate, stagger } from 'framer-motion'

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

const tabs = [
  {
    title: 'Logs',
    description: 'View logs for a service running in a container.',
    command: 'lxc exec my-container -- rc-service my-app logs',
    output: `
    2024-12-09 03:12:28.137208727  03:12:28.136 request_id=GA9jpnTTvVEtqKYAAAkS [info] POST /provision/automation/callback
    2024-12-09 03:12:28.157291698  03:12:28.156 request_id=GA9jpnTTvVEtqKYAAAkS [info] Sent 201 in 20ms
    2024-12-09 03:12:33.303312960  03:12:33.302 request_id=GA9jp6i-IlEtqKYAAAki [info] GET /provision/storages/519
    2024-12-09 03:12:33.320004273  03:12:33.318 request_id=GA9jp6i-IlEtqKYAAAki [info] Sent 200 in 15ms
    2024-12-09 03:12:34.722280333  03:12:34.721 request_id=GA9jp_1MslAtqKYAAAlC [info] POST /provision/automation/callback
    2024-12-09 03:12:34.736048715  03:12:34.735 request_id=GA9jp_1MslAtqKYAAAlC [info] Sent 201 in 14ms
    2024-12-09 03:14:17.336466066  03:14:17.335 request_id=GA9jv-GUXTo6EyYAAAlS [info] POST /provision/automation/callback
    2024-12-09 03:14:17.349211066  03:14:17.347 request_id=GA9jv-GUXTo6EyYAAAlS [info] Sent 201 in 11ms
    2024-12-09 03:14:17.417701433  03:14:17.416 request_id=GA9jv-ZuYLA6EyYAAAli [info] DELETE /provision/storages/519
    2024-12-09 03:14:17.456382156  03:14:17.454 request_id=GA9jv-ZuYLA6EyYAAAli [info] Sent 200 in 38ms
    2024-12-09 03:14:17.472360822  03:14:17.471 [info] {"args":{"organization_id":2,"type":"storage","uid":519},"id":3123651,"meta":{},"system_time":1733714057471543876,"max_attempts":1,"queue":"insterra","worker":"Instellar.Insterra.Blueprints.Component.Deactivate","source":"oban","event":"job:start","attempt":1,"tags":[]}
    2024-12-09 03:14:17.712398224  03:14:17.711 [info] {"args":{"organization_id":2,"type":"storage","uid":519},"id":3123651,"meta":{},"state":"success","max_attempts":1,"queue":"insterra","worker":"Instellar.Insterra.Blueprints.Component.Deactivate","source":"oban","event":"job:stop","duration":236784,"attempt":1,"tags":[],"queue_time":30265}
    2024-12-09 03:14:53.376384842  03:14:53.375 request_id=GA9jyEW1mtw6EyYAAAly [info] GET /dashboard/artello
    2024-12-09 03:14:53.409928164  03:14:53.409 request_id=GA9jyEW1mtw6EyYAAAly [info] Sent 200 in 34ms
    2024-12-09 03:14:54.198217250  03:14:54.197 [info] CONNECTED TO Phoenix.LiveView.Socket in 31µs
    2024-12-09 03:14:54.198222880    Transport: :websocket
    2024-12-09 03:14:54.198224980    Serializer: Phoenix.Socket.V2.JSONSerializer
    2024-12-09 03:14:54.198230900    Parameters: %{"_csrf_token" => "DzcDIggeHgwJNx4pdmo9LwF_HXYLAxk1Ap6CyKogyOdoAYniqNVO83zQ", "_live_referer" => "undefined", "_mounts" => "0", "_track_static" => %{"0" => "https://sandbox.opsmaru.dev/assets/app-32d36259c0099b8b1c62a0387a61f0c9.css?vsn=d", "1" => "https://sandbox.opsmaru.dev/themes/code-89b599a7aaa52a0c262bad6c4a4e80f2.css?vsn=d", "2" => "https://sandbox.opsmaru.dev/themes/screenshots-f5ac732c0d831304565f918859c74461.css?vsn=d", "3" => "https://sandbox.opsmaru.dev/assets/app-4e6bbdd2e22e679f8bb75cc817ca4b6a.js?vsn=d"}, "locale" => "en-US", "timezone" => "Asia/Bangkok", "timezone_offset" => "7", "vsn" => "2.0.0"}
    2024-12-09 03:17:45.313436306  03:17:45.312 request_id=GA9j8E33XjNPnIwAAAnC [info] POST /provision/automation/callback
    2024-12-09 03:17:45.345161739  03:17:45.342 request_id=GA9j8E33XjNPnIwAAAnC [info] Sent 201 in 29ms
    2024-12-09 03:18:14.872795120  03:18:14.870 request_id=GA9j9y_JiHdPnIwAAAnS [info] POST /provision/automation/callback
    2024-12-09 03:18:14.886371357  03:18:14.885 request_id=GA9j9y_JiHdPnIwAAAnS [info] Sent 201 in 14ms
    2024-12-09 03:18:22.634052177  03:18:22.632 request_id=GA9j-P5xLntPnIwAAAni [info] POST /provision/storages
    2024-12-09 03:18:22.684365108  03:18:22.681 request_id=GA9j-P5xLntPnIwAAAni [info] Sent 201 in 49ms
    2024-12-09 07:10:22.060604980  07:10:22.060 [info] POST https://github.com/login/oauth/access_token -> 200 (197.953 ms)
    2024-12-09 07:10:23.807853293  07:10:23.807 request_id=GA9wokUVYXPzxk0AAApy [info] POST /hook/github/installations
    2024-12-09 07:10:23.826560737  07:10:23.826 request_id=GA9wokUVYXPzxk0AAApy [info] Sent 200 in 19ms
    `
  },
  {
    title: 'Run Migrations / Tasks',
    description: 'Run database migrations or tasks for a service running in a container.',
    command: 'lxc exec my-container -- rc-service my-app migrate',
    output: `
    == 20211210123456 CreateUsers: migrating =====================================
    -- create_table(:users)
      -> 0.0015s
    -- add_index(:users, :email, {:unique=>true})
      -> 0.0010s
    == 20211210123456 CreateUsers: migrated (0.0025s) ============================
    `
  },
  {
    title: 'Console Access',
    description: 'Access the console for a service running in a container.',
    command: 'lxc exec my-container -- ash',
    output: '$ █'
  }
]

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

export function Commands() {
  const [activeTab, setActiveTab] = useState(null);
  const [activeCommand, setActiveCommand] = useState(null);
  const [activeOutput, setActiveOutput] = useState(null);
  const [scope, animate] = useAnimate()

  useEffect(() => {    
    setActiveCommand(tabs[activeTab]?.command)
    setActiveOutput(tabs[activeTab]?.output)
  }, [activeTab])

  useEffect(() => {
    if (activeTab !== null) {
      const animation = animate("span", { opacity: 1 }, { 
        delay: stagger(0.025)
      })

      animation.then(() => {
        animate(".output", { opacity: 1 }, { delay: stagger(0.05) })
      })
    }
  }, [activeCommand])

  return (
    <div className="flex px-10 gap-x-4 mt-4">
      <Window width={800} height={600} className="z-0 absolute left-1/2 -translate-x-1/2 -bottom-8"/>
      {tabs.map((tab, index) => 
      <button key={`demo-${index}`} onClick={() => setActiveTab(index) } data-active={activeTab === index} className="text-left border border-slate-700 rounded-lg px-4 py-4 z-10 bg-slate-800/90 hover:bg-slate-700/90 hover:border-slate-400 data-[active=true]:bg-slate-500/90 data-[active=true]:border-white">
        <h2 className="text-white font-semibold">{tab.title}</h2>
        <p className="mt-4 text-white">{tab.description}</p>
      </button>)}
      <div ref={scope} key={activeTab} className="absolute inset-0 px-6">
        <div className="relative w-full h-full overflow-hidden">
          <div className="absolute left-3 bottom-0 mb-2 text-xs font-mono overflow-hidden text-slate-500">
            {activeOutput?.split("\n\n").map((line, index) => 
              <div className="my-6" key={index}>{line.split("\n").map((l, idx) => <motion.p initial={{opacity: 0}} className="output" key={`line-${idx}`}>{l}</motion.p>)}</div>
            )}
          </div>
          <div className="absolute left-3 bottom-0.5 text-xs text-slate-500 font-mono">
            {activeCommand?.split('').map((char, index) => <motion.span initial={{opacity: 0}} key={`demo-${char}-${index}`} className='text-slate-400'>{char}</motion.span>)}
          </div>
        </div>
      </div>
    </div>
  )
}

export function mountCommands() {
  const domNode = this.el;
  const root = createRoot(domNode);
  
  root.render(<Commands />);
}