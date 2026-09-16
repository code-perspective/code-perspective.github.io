# Repository Guide

This document explains how people and coding agents should work in this repository. It is intentionally practical: follow these conventions to keep the site easy to maintain and compatible with GitHub Pages.

## What This Repository Contains

This is Shruthi Gorantala's personal website. It is a statically generated Jekyll site based on Academic Pages and hosted with GitHub Pages.

The public site has three primary views:

- `/` is the biography and profile page.
- `/talks/` lists talks and presentations.
- `/publications/` lists papers first and patents afterward.

Talks and publications are stored as structured Markdown files. Jekyll reads their YAML front matter, sorts them by date, and renders them through a shared timeline component.

## Repository Map

| Path | Purpose |
| --- | --- |
| `_pages/about.md` | Home-page biography. |
| `_pages/talks.html` | Talks listing and ordering logic. |
| `_pages/publications.html` | Paper and patent listing logic. |
| `_talks/` | One Markdown file per talk or panel. |
| `_publications/` | One Markdown file per paper or patent. |
| `_templates/` | Starting templates for new content entries. |
| `_includes/timeline-entry.html` | Shared talk/publication timeline markup. |
| `_sass/_timeline.scss` | Timeline presentation and responsive styling. |
| `_layouts/` | Full-page Jekyll layouts. |
| `_config.yml` | Site identity, profile links, collections, and plugins. |
| `_data/navigation.yml` | Header navigation links. |
| `files/` | PDFs and other files hosted by the site. |
| `images/` | Profile and site images. |
| `script/validate_content.rb` | Content-schema and local-resource validator. |
| `.github/workflows/validate.yml` | Pull-request and `master` validation. |
| `_site/` | Generated output. Never edit or commit this directory. |

Most routine content updates should touch only `_talks/`, `_publications/`, `_pages/about.md`, `files/`, or `images/`.

## General Working Rules

1. Check `git status` before editing and preserve unrelated work.
2. Keep changes narrowly related to the requested content or presentation update.
3. Use the existing front matter field names. The validator rejects legacy names such as `category`, `excerpt`, `paperurl`, `slidesurl`, and `type`.
4. Do not change a published `permalink` unless a redirect is also added and the URL change is intentional.
5. Do not edit generated files in `_site/`.
6. Do not add JavaScript for ordinary content changes. Jekyll and Liquid already handle collection rendering.
7. Keep external URLs in front matter rather than writing custom links into listing pages.
8. Run content validation and a strict build before considering work complete.

## File Naming And Ordering

Name collection entries using:

```text
YYYY-MM-DD-short-descriptive-title.md
```

The `date` field controls display order, not the filename. Talks and papers appear in reverse chronological order. Patents appear after all papers and are reverse chronological within the patent group.

Use a real or best-known event/publication date in `YYYY-MM-DD` format. If only a month is known, use the first day of that month consistently.

## Adding A Talk

1. Start from `_templates/talk.md`.
2. Create a new file in `_talks/` using the date-based filename convention.
3. Fill every required field.
4. Remove optional URL fields that do not apply instead of leaving placeholder URLs.
5. Run the validation and build commands below.

Required talk fields:

```yaml
---
title: "Talk title"
kind: "Invited Talk"
permalink: /talks/2026-09-01-short-title
date: 2026-09-01
venue: "Event name"
location: "City, Region"
description: "One concise sentence describing the talk."
---
```

Optional talk fields:

```yaml
event_url: "https://example.com/event"
slides_url: "https://example.com/slides"
video_url: "https://example.com/video"
```

`kind` is a short role or format such as `Invited Talk`, `Keynote`, `Panelist`, `Meetup Talk`, or `Working Group Session Lead`.

## Adding A Paper

1. Start from `_templates/publication.md`.
2. Create a new file in `_publications/`.
3. Set `kind: paper` exactly.
4. Add a stable paper URL and concise description.
5. Add optional related resources only when they are useful.

Required paper fields:

```yaml
---
title: "Publication title"
kind: paper
permalink: /publication/2026-09-01-short-title
date: 2026-09-01
venue: "Journal, conference, workshop, or repository"
description: "One concise sentence describing the publication."
paper_url: "https://example.com/paper"
---
```

Optional publication fields:

```yaml
citation: "Full citation text."
slides_url: "https://example.com/slides"
resources:
  - label: "Project"
    url: "https://example.com/project"
```

Each resource must contain both a short `label` and a valid `url`.

## Adding A Patent

Follow the paper workflow, but start from `_templates/patent.md` and set:

```yaml
kind: patent
```

Use the patent or application number as `venue`, and use the corresponding Google Patents page as `paper_url`. The publications page automatically places patents after papers.

## Updating An Entry

- Edit the existing Markdown file rather than creating a duplicate.
- Keep its filename and `permalink` stable when correcting text, dates, venues, or resource links.
- Update `date` only when the displayed chronology was genuinely wrong.
- Use `description` for listing copy; do not introduce `excerpt`.
- Use snake_case URL fields: `paper_url`, `event_url`, `slides_url`, and `video_url`.
- For a locally hosted resource, place the file under `files/` and use a root-relative URL such as `/files/slides.pdf`.

The shared timeline automatically opens resource links in a new tab. Do not add HTML attributes separately to each entry.

## Deleting An Entry

1. Delete the corresponding file from `_talks/` or `_publications/`.
2. Search for its permalink, title, and local resource filenames before removing related assets.
3. Delete a file from `files/` or `images/` only when no remaining page references it.
4. Run validation and build the site to catch broken local references.

For an already published URL, consider retaining the page or adding `redirect_from` to a suitable destination instead of creating a broken external link.

## Editing Pages And Presentation

- Edit biography copy in `_pages/about.md`.
- Edit header links in `_data/navigation.yml`.
- Edit profile details and social links in `_config.yml`.
- Edit shared talk/publication markup in `_includes/timeline-entry.html`.
- Edit timeline styling in `_sass/_timeline.scss`.

Talk and publication titles are intentionally emphasized without linking to detail pages. Resource links such as Event, Paper, Patent, Slides, and Video are the primary actions.

Keep timeline rows compact, readable, and responsive. Reuse the existing classes rather than adding separate talk-only or publication-only versions unless the two views genuinely need different behavior.

Changes to `_config.yml` require restarting the local Jekyll server.

## Local Development

Install dependencies once:

```bash
bundle install
```

Start the local site with automatic rebuilding:

```bash
bundle exec jekyll serve --livereload
```

Open <http://localhost:4000>.

Run the required checks before committing:

```bash
bundle exec ruby script/validate_content.rb
bundle exec jekyll build --strict_front_matter
```

The validator checks required fields, publication kinds, legacy field names, duplicate permalinks, and root-relative resource files. GitHub Actions runs the same validation and build for pull requests and pushes to `master`.

## JavaScript And Theme Files

The compiled `assets/js/main.min.js` is checked in and is sufficient for normal site work. Node is needed only when changing theme JavaScript under `assets/js/`:

```bash
npm install
npm run build:js
```

Avoid broad changes to inherited theme layouts, includes, Sass, or vendor files unless the task requires them. Those files form the site framework even when they are not edited frequently.

## Completion Checklist

- The requested content or presentation change is visible in the appropriate generated page.
- Talks remain reverse chronological.
- Publications show papers first and patents last.
- Published permalinks remain stable.
- External resources use the established front matter fields.
- Local assets exist and are still referenced.
- `script/validate_content.rb` passes.
- `jekyll build --strict_front_matter` passes.
- `git diff --check` reports no whitespace errors.
- No generated `_site/` files or unrelated changes are included.