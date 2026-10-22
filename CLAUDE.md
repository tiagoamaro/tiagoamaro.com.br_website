# Project notes

## Structure

Plain static HTML served by GitHub Pages from the `main` branch. `.nojekyll`
stops Pages from running Jekyll. The pages came from a final `jekyll build`, so
URLs keep Jekyll's pretty permalinks as real folders:

- `/` (`index.html`): About page
- `/posts/`: post index, newest first
- `/YYYY/MM/DD/slug/index.html`: blog posts
- `/mastodon/`, `/quotes/`: other pages
- `404.html`: standalone, no site CSS

There are no templates. The `<head>`, sidebar and scripts are duplicated in
every page, so a shared markup change is a find-and-replace across all HTML
files. A new post means a new `index.html` under its date path plus an entry
in `posts/index.html`. Disqus threads are keyed by the post URL
(`this.page.identifier`), so never move a post.

## CSS

Tailwind v4: `_tailwind/input.css` → `public/css/tailwind.css` via `make
build`. The compiled CSS is committed. `make build` also stamps the CSS
hash into each page's `tailwind.css?v=` link, since Cloudflare caches the
stylesheet for 4h and would otherwise serve old CSS to new HTML. Tailwind finds classes by scanning the
HTML files.

Vanilla Tailwind v4 default scale values only: no arbitrary values
(`w-[123px]`), no theme extensions, unless explicitly approved. The only
`@theme` tokens are `--font-brand` (Berkshire Swash wordmark) and the
terracotta logo palette: `terracotta`, `cream`, `gold`, `cocoa`.

Markdown-era raw tags (`h1`-`h6`, `p`, `blockquote`, `table`, `pre`, etc.)
carry no classes, so they are styled in the `@layer base` block of
`_tailwind/input.css`.

`public/css/syntax.css` holds the Rouge syntax highlighting colors inside
`@layer legacy`. Every page declares `@layer theme, base, legacy, components,
utilities;` before loading stylesheets, so legacy rules beat Preflight but
lose to Tailwind utilities. Keep that declaration first in `<head>`.

## Do not touch: third-party / vendored code

`public/js/emfed/` is the vendored Mastodon feed embed
(<https://github.com/sampsyo/emfed>): `emfed.js`, `core.js`, `client.js`,
`toots.css` and its dependency `dompurify.mjs` (resolved via an import map in
each page). Its classnames (`.toots`, `.toot`, `.user`, `.avatar`, etc.) are
injected at runtime. Do not convert `toots.css` to Tailwind or edit these
files.
