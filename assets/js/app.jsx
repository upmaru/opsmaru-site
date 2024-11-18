// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
import React from "react";
import { createRoot } from "react-dom/client";

import { Broadcast } from "../components/broadcast";
import { Slider } from "../components/slider";
import { MobileNav } from "../components/mobile-nav";
import { Categories } from '../components/categories';
import { Player } from '../components/player';
import { Technologies } from '../components/technologies';
import { Circles } from '../components/circles';

import { animate, scroll } from 'motion'

function mountCategories() {
  const domNode = this.el;
  const root = createRoot(domNode);

  let { categories, selected } = this.el.dataset;

  categories = JSON.parse(categories);

  root.render(<Categories categories={categories} selected={selected} />);
}

function mountSlider() {
  const domNode = this.el;
  const root = createRoot(domNode);

  let { description, testimonials } = this.el.dataset;

  testimonials = JSON.parse(testimonials);

  root.render(<Slider description={description} testimonials={testimonials} />);
}

function mountMobileNav() {
  const domNode = this.el;
  const root = createRoot(domNode);

  let { links } = this.el.dataset;

  links = JSON.parse(links);

  root.render(<MobileNav links={links} />);
}

function mountBroadcast() {
  const domNode = this.el;
  const root = createRoot(domNode);

  root.render(<Broadcast />);
}

function mountSlideScroll() {
  const { el } = this;
  const items = el.querySelectorAll('.slide-item');

  const backgroundEl = el.querySelector('#slides-background');

  items.forEach((item) => {
    scroll(
      animate(item,  { opacity: [0, 1, 1, 0], scale: [0.8, 1, 1, 0.8] }, { ease: "linear" }), {
        target: item,
        offset: ["start end", "end end", "start start", "end start"],
      }
    )
  })

  const segmentLength = 1 / items.length;
  items.forEach((item, i) => {
    const header = item.querySelector("h2.slide-title");

    scroll(animate(header, { x: [0, 150] }, { ease: "linear" }), {
      target: el,
      offset: [
        [i * segmentLength, 1],
        [(i + 1) * segmentLength, 0],
      ],
    });
  });

  items.forEach((item, i) => {
    const header = item.querySelector(".slide-description");

    scroll(animate(header, { x: [100, -50] }, { ease: "linear" }), {
      target: el,
      offset: [
        [i * segmentLength, 1],
        [(i + 1) * segmentLength, 0],
      ],
    });
  });

  scroll(
    animate(
      "div#slides-container",
      {
        transform: ["none", `translateX(-${items.length - 1}00vw)`],
      }, 
      { ease: "easeInOut" }
    ),
    { target: el }
  )

  const backgroundRoot = createRoot(backgroundEl);
  backgroundRoot.render(<Circles container={el} />);
}

function mountTechnologies() {
  const domNode = this.el;
  const root = createRoot(domNode);

  let { technologies } = this.el.dataset;

  technologies = JSON.parse(technologies);

  root.render(<Technologies technologies={technologies} />);
}

let Hooks = {};

Hooks.MountBroadcast = {
  mounted: mountBroadcast,
  updated: mountBroadcast,
};

Hooks.MountSlider = {
  mounted: mountSlider,
  updated: mountSlider,
};

Hooks.MountMobileNav = {
  mounted: mountMobileNav,
  updated: mountMobileNav,
};

Hooks.MountTechnologies = {
  mounted: mountTechnologies,
  updated: mountTechnologies,
}

Hooks.MountPlayer = {
  mounted() {
    const domNode = this.el;
    const root = createRoot(domNode);

    let { movie } = this.el.dataset;

    movie = JSON.parse(movie);

    root.render(<Player movie={movie} />);
  }
}

Hooks.MountCategories = {
  mounted: mountCategories,
  updated: mountCategories,
}

Hooks.MountSlideScroll = {
  mounted: mountSlideScroll,
  updated: mountSlideScroll,
}

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/site/live", Socket, {
  hooks: Hooks,
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { '0': "#67e8f9", '0.75': '#c084fc', '1.0': '#7c3aed' }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
