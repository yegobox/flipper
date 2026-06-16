// Extends the shared Flipper icon set (modal/icons.jsx) with a few glyphs the
// product editor needs. Runs after icons.jsx, so window.Icons already exists.
(function () {
  const I = ({ d, size = 16, stroke = 1.5, fill = 'none', extra }) => (
    React.createElement('svg', {
      width: size, height: size, viewBox: '0 0 24 24', fill,
      stroke: 'currentColor', strokeWidth: stroke, strokeLinecap: 'round', strokeLinejoin: 'round', 'aria-hidden': true,
    }, typeof d === 'string' ? React.createElement('path', { d }) : d, extra)
  );
  Object.assign(window.Icons, {
    Palette: (p) => <I {...p} d={<><path d="M12 3a9 9 0 0 0 0 18c1.4 0 2-1 2-1.8 0-.6-.3-1-.6-1.4-.3-.4-.6-.8-.6-1.3 0-1 .8-1.5 1.8-1.5H16a5 5 0 0 0 5-5c0-3.9-4-7-9-7Z" /><circle cx="7.5" cy="11.5" r="1.1" fill="currentColor" stroke="none" /><circle cx="11" cy="7.5" r="1.1" fill="currentColor" stroke="none" /><circle cx="16" cy="8.5" r="1.1" fill="currentColor" stroke="none" /></>} />,
    Camera: (p) => <I {...p} d={<><path d="M4 8h3l1.5-2.2A1 1 0 0 1 9.3 5h5.4a1 1 0 0 1 .8.4L17 8h3a1 1 0 0 1 1 1v9a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V9a1 1 0 0 1 1-1Z" /><circle cx="12" cy="13" r="3.2" /></>} />,
    Percent: (p) => <I {...p} d={<><path d="M19 5 5 19" /><circle cx="7" cy="7" r="2" /><circle cx="17" cy="17" r="2" /></>} />,
    Pencil: (p) => <I {...p} d={<><path d="M4 20h4l10-10a2 2 0 0 0-3-3L5 17z" /><path d="m14 6 3 3" /></>} />,
    Globe: (p) => <I {...p} d={<><circle cx="12" cy="12" r="9" /><path d="M3 12h18" /><path d="M12 3c2.5 2.5 3.5 5.8 3.5 9s-1 6.5-3.5 9c-2.5-2.5-3.5-5.8-3.5-9s1-6.5 3.5-9Z" /></>} />,
    Layers: (p) => <I {...p} d={<><path d="m12 3 9 5-9 5-9-5z" /><path d="m3 12 9 5 9-5" /><path d="m3 16 9 5 9-5" /></>} />,
    Scan: (p) => <I {...p} d={<><path d="M4 8V6a2 2 0 0 1 2-2h2M16 4h2a2 2 0 0 1 2 2v2M20 16v2a2 2 0 0 1-2 2h-2M8 20H6a2 2 0 0 1-2-2v-2" /><path d="M4 12h16" /></>} />,
    Lock: (p) => <I {...p} d={<><rect x="4.5" y="10.5" width="15" height="10" rx="2" /><path d="M8 10.5V8a4 4 0 0 1 8 0v2.5" /><circle cx="12" cy="15.5" r="1.2" fill="currentColor" stroke="none" /></>} />,
  });
})();
