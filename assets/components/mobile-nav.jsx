import React from "react";
import { motion } from "framer-motion";

export function MobileNav({ links }) {
  return (
    <>
      <div className="flex flex-col gap-6 py-4">
        {links.map(({ path, title }, linkIndex) => (
          <motion.div
            initial={{ opacity: 0, rotateX: -90 }}
            animate={{ opacity: 1, rotateX: 0 }}
            transition={{
              duration: 0.15,
              ease: "easeInOut",
              rotateX: { duration: 0.3, delay: linkIndex * 0.1 },
            }}
            key={path}
          >
            <a
              href={path}
              data-phx-link="redirect"
              data-phx-link-state="push"
              className="text-base font-medium text-slate-950"
            >
              {title}
            </a>
          </motion.div>
        ))}
      </div>
      <div className="absolute left-1/2 w-screen -translate-x-1/2">
        <div className="absolute inset-x-0 top-0 border-t border-black/5" />
        <div className="absolute inset-x-0 top-2 border-t border-black/5" />
      </div>
    </>
  );
}
