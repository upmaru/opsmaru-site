import React from "react";
import * as Headless from "@headlessui/react";
import { ArrowLongRightIcon } from "@heroicons/react/20/solid";
import { clsx } from "clsx";
import {
  motion,
  useMotionValueEvent,
  useScroll,
  useSpring,
} from "framer-motion";
import { useCallback, useLayoutEffect, useRef, useState } from "react";
import useMeasure from "react-use-measure";
import { Container } from "./container";

// const testimonials = [
//   {
//     img: "/images/testimonials/tina-yards.jpg",
//     name: "Tina Yards",
//     title: "VP of Sales, Protocol",
//     quote:
//       "Thanks to Radiant, we’re finding new leads that we never would have found with legal methods.",
//   },
//   {
//     img: "/images/testimonials/conor-neville.jpg",
//     name: "Conor Neville",
//     title: "Head of Customer Success, TaxPal",
//     quote:
//       "Radiant made undercutting all of our competitors an absolute breeze.",
//   },
//   {
//     img: "/images/testimonials/amy-chase.jpg",
//     name: "Amy Chase",
//     title: "Head of GTM, Pocket",
//     quote:
//       "We closed a deal in literally a few minutes because we knew their exact budget.",
//   },
//   {
//     img: "/images/testimonials/veronica-winton.jpg",
//     name: "Veronica Winton",
//     title: "CSO, Planeteria",
//     quote:
//       "We’ve managed to put two of our main competitors out of business in 6 months.",
//   },
//   {
//     img: "/images/testimonials/dillon-lenora.jpg",
//     name: "Dillon Lenora",
//     title: "VP of Sales, Detax",
//     quote: "I was able to replace 80% of my team with RadiantAI bots.",
//   },
//   {
//     img: "/images/testimonials/harriet-arron.jpg",
//     name: "Harriet Arron",
//     title: "Account Manager, Commit",
//     quote:
//       "I’ve smashed all my targets without having to speak to a lead in months.",
//   },
// ];

function TestimonialCard({
  name,
  title,
  img,
  children,
  bounds,
  scrollX,
  ...props
}) {
  let ref = useRef(null);

  let computeOpacity = useCallback(() => {
    let element = ref.current;
    if (!element || bounds.width === 0) return 1;

    let rect = element.getBoundingClientRect();

    if (rect.left < bounds.left) {
      let diff = bounds.left - rect.left;
      let percent = diff / rect.width;
      return Math.max(0.5, 1 - percent);
    } else if (rect.right > bounds.right) {
      let diff = rect.right - bounds.right;
      let percent = diff / rect.width;
      return Math.max(0.5, 1 - percent);
    } else {
      return 1;
    }
  }, [ref, bounds.width, bounds.left, bounds.right]);

  let opacity = useSpring(computeOpacity(), {
    stiffness: 154,
    damping: 23,
  });

  useLayoutEffect(() => {
    opacity.set(computeOpacity());
  }, [computeOpacity, opacity]);

  useMotionValueEvent(scrollX, "change", () => {
    opacity.set(computeOpacity());
  });

  return (
    <motion.div
      ref={ref}
      style={{ opacity }}
      {...props}
      className="relative flex aspect-[9/16] w-72 shrink-0 snap-start scroll-ml-[var(--scroll-padding)] flex-col justify-end overflow-hidden rounded-3xl sm:aspect-[3/4] sm:w-96"
    >
      <img
        alt={img.alt}
        src={img.url}
        className="absolute inset-x-0 top-0 aspect-square w-full object-cover"
      />
      <div
        aria-hidden="true"
        className="absolute inset-0 rounded-3xl bg-gradient-to-t from-slate-900 ring-1 ring-inset ring-slate-950/10 sm:from-25%"
      />
      <figure className="relative p-10">
        <blockquote>
          <p className="relative text-md text-white">
            <span aria-hidden="true" className="absolute -translate-x-full">
              “
            </span>
            {children}
            <span aria-hidden="true" className="absolute">
              ”
            </span>
          </p>
        </blockquote>
        <figcaption className="mt-6 border-t border-white/20 pt-6">
          <p className="text-sm/6 font-medium text-white">{name}</p>
          <p className="text-sm/6 font-medium">
            <span className="bg-gradient-to-r from-cyan-300 from-[28%] via-[#c084fc] via-[70%] to-[#7c3aed] bg-clip-text text-transparent">
              {title}
            </span>
          </p>
        </figcaption>
      </figure>
    </motion.div>
  );
}

function CallToAction({ description }) {
  return (
    <div>
      <p className="max-w-sm text-sm/6 text-slate-600">
        {description}
      </p>
      <div className="mt-2">
        <a
          href="/auth/users/log_in"
          className="inline-flex items-center gap-2 text-sm/6 font-medium text-cyan-500"
        >
          Get started
          <ArrowLongRightIcon className="size-5" />
        </a>
      </div>
    </div>
  );
}

export function Slider({ description, testimonials }) {
  let scrollRef = useRef(null);
  let { scrollX } = useScroll({ container: scrollRef });
  let [setReferenceWindowRef, bounds] = useMeasure();
  let [activeIndex, setActiveIndex] = useState(0);

  useMotionValueEvent(scrollX, "change", (x) => {
    setActiveIndex(Math.floor(x / scrollRef.current.children[0].clientWidth));
  });

  function scrollTo(index) {
    let gap = 32;
    let width = scrollRef.current.children[0].offsetWidth;
    scrollRef.current.scrollTo({ left: (width + gap) * index });
  }

  return (
    <>
      <div
        ref={scrollRef}
        className={clsx([
          "mt-16 flex gap-8 px-[var(--scroll-padding)]",
          "[scrollbar-width:none] [&::-webkit-scrollbar]:hidden",
          "snap-x snap-mandatory overflow-x-auto overscroll-x-contain scroll-smooth",
          "[--scroll-padding:max(theme(spacing.6),calc((100vw-theme(maxWidth.2xl))/2))] lg:[--scroll-padding:max(theme(spacing.8),calc((100vw-theme(maxWidth.7xl))/2))]",
        ])}
      >
        {testimonials.map(({ cover, name, position, quote }, testimonialIndex) => (
          <TestimonialCard
            key={testimonialIndex}
            name={name}
            title={position}
            img={cover}
            bounds={bounds}
            scrollX={scrollX}
            onClick={() => scrollTo(testimonialIndex)}
          >
            {quote}
          </TestimonialCard>
        ))}
        <div className="w-[42rem] shrink-0 sm:w-[54rem]" />
      </div>
      <Container className="mt-16">
        <div className="flex justify-between">
          <CallToAction description={description} />
          <div className="hidden sm:flex sm:gap-2">
            {testimonials.map(({ name }, testimonialIndex) => (
              <Headless.Button
                key={testimonialIndex}
                onClick={() => scrollTo(testimonialIndex)}
                data-active={
                  activeIndex === testimonialIndex ? true : undefined
                }
                aria-label={`Scroll to testimonial from ${name}`}
                className={clsx(
                  "size-2.5 rounded-full border border-transparent bg-slate-300 transition",
                  "data-[active]:bg-slate-400 data-[hover]:bg-slate-400",
                  "forced-colors:data-[active]:bg-[Highlight] forced-colors:data-[focus]:outline-offset-4",
                )}
              />
            ))}
          </div>
        </div>
      </Container>
    </>
  );
}
