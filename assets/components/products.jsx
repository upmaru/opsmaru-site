import React from 'react'
import { createRoot } from "react-dom/client"
import { Menu, MenuButton, MenuItem, MenuItems } from '@headlessui/react'
import {
  CheckIcon,
  ChevronUpDownIcon,
} from '@heroicons/react/16/solid'

function Products({ products, interval, selected }) {
  return (
    <Menu>
      <MenuButton className="flex items-center justify-between gap-2 font-medium">
        {products.find(({ reference }) => reference === selected)?.name || products[0].name}
        <ChevronUpDownIcon className="size-4 fill-slate-900" />
      </MenuButton>
      <MenuItems
        anchor="bottom start"
        className="min-w-40 rounded-lg bg-white p-1 shadow-lg ring-1 ring-gray-200 [--anchor-gap:6px] [--anchor-offset:-4px] [--anchor-padding:10px]"
      >
        {products.map((product) => (
          <MenuItem key={`product-${product.index}`}>
            <a 
              href={`/our-product/pricing?interval=${interval}&product=${product.reference}`}
              data-phx-link="patch"
              data-phx-link-state="push"
              data-selected={product.reference === selected ? true : undefined}
              className="group grid grid-cols-[16px,1fr] items-center gap-2 rounded-md px-2 py-1 data-[focus]:bg-gray-950/5"
            >
              <CheckIcon className="hidden size-4 group-data-[selected]:block" />
              <p className="col-start-2 text-sm/6">{product.name}</p>
            </a>
          </MenuItem>
        ))}
      </MenuItems>
    </Menu>
  )
}

export function mountProducts() {
  const domNode = this.el;
  const root = createRoot(domNode);
  let { products, interval, selected } = this.el.dataset;

  products = JSON.parse(products);

  root.render(<Products products={products} interval={interval} selected={selected} />)
}