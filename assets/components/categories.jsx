import React, { useState } from 'react'
import { Menu, MenuButton, MenuItem, MenuItems } from '@headlessui/react'
import {
  CheckIcon,
  ChevronUpDownIcon,
} from '@heroicons/react/16/solid'

export function Categories({ categories, selected }) {
  return (
    <Menu>
      <MenuButton className="flex items-center justify-between gap-2 font-medium">
        {categories.find(({ slug }) => slug === selected)?.name ||
          'All categories'}
        <ChevronUpDownIcon className="size-4 fill-slate-900" />
      </MenuButton>
      <MenuItems
        anchor="bottom start"
        className="min-w-40 rounded-lg bg-white p-1 shadow-lg ring-1 ring-gray-200 [--anchor-gap:6px] [--anchor-offset:-4px] [--anchor-padding:10px]"
      >
        <MenuItem>
          <a
            href="/blog"
            data-phx-link="redirect"
            data-phx-link-state="push"
            data-selected={selected === undefined ? true : undefined}
            className="group grid grid-cols-[1rem,1fr] items-center gap-2 rounded-md px-2 py-1 data-[focus]:bg-gray-950/5"
          >
            <CheckIcon className="hidden size-4 group-data-[selected]:block" />
            <p className="col-start-2 text-sm/6">All categories</p>
          </a>
        </MenuItem>
        {categories.map((category) => (
          <MenuItem key={category.slug}>
            <a
              href={`/blog?category=${category.slug}`}
              data-phx-link="redirect"
              data-phx-link-state="push"
              data-selected={category.slug === selected ? true : undefined}
              className="group grid grid-cols-[16px,1fr] items-center gap-2 rounded-md px-2 py-1 data-[focus]:bg-gray-950/5"
            >
              <CheckIcon className="hidden size-4 group-data-[selected]:block" />
              <p className="col-start-2 text-sm/6">{category.name}</p>
            </a>
          </MenuItem>
        ))}
      </MenuItems>
    </Menu>
  )
}