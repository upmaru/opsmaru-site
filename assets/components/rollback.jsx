import React from 'react'

const timelineItems = [
  {
    who: "New intern",
    message: "YOLO, Leeeerrroooy Jenkins!!!. Let's GO! 🚀",
    when: 'now',
  },
  {
    who: "Senior developer",
    message: 'Changed the color scheme, and tests.',
    when: '1d ago',
  },
  {
    who: "Senior developer",
    message: 'Added checkout button, and added tests.',
    when: '2d ago',
  },
  {
    who: "Senior developer",
    message: 'Setup checkout page and added product listing.',
    when: '5d ago',
  },
  {
    who: "Senior developer",
    message: 'Integrated payment gateway.',
    when: '6d ago',
  }
]

function Item({ who, message, when }) {
  return (
    <li className="relative flex gap-x-4">
      <div className="absolute -bottom-6 left-0 top-0 flex w-6 justify-center">
        <div className="w-px bg-slate-600"></div>
      </div>
      <div className="relative flex size-6 flex-none items-center justify-center">
        <div className="size-1.5 rounded-full bg-slate-600 ring-1 ring-slate-400"></div>
      </div>
      <p className="flex-auto py-0.5 text-xs/5 text-slate-400"><span className="font-bold text-slate-200">{who}</span> {message}</p>
      <time className="flex-none py-0.5 text-xs/5 text-slate-300">{when}</time>
    </li>
  )
}

export function Timeline() {
  return (
    <div className="absolute inset-0 top-8 z-10 flex items-center justify-center bg-slate-900 ring-1 ring-slate-700 overflow-hidden">
      <div className="relative p-8">
        <ul role="list" className="space-y-4">
          <li className="relative flex gap-x-4 py-6">
            <div className="absolute -bottom-6 left-0 top-0 flex w-6 justify-center">
              <div className="w-px bg-slate-600"></div>
            </div>
          </li>
          {timelineItems.map((item, index) => 
            <Item key={index} who={item.who} message={item.message} when={item.when} />
          )}
        </ul>
      </div>
    </div>
  )
}