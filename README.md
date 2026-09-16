# Shruthi Gorantala's website

Personal website built with Jekyll and hosted on GitHub Pages.

See [AGENTS.md](AGENTS.md) for the repository structure, content schemas, and detailed add, update, and deletion workflows for both human contributors and coding agents.

## Local development

Install Ruby and Bundler once, then run:

```bash
bundle install
bundle exec jekyll serve --livereload
```

Open <http://localhost:4000>. Changes to `_config.yml` require a server restart.

Before pushing changes, run the same checks used by CI:

```bash
bundle exec ruby script/validate_content.rb
bundle exec jekyll build --strict_front_matter
```

## Content

- `_pages/about.md` contains the home page.
- `_talks/` contains one Markdown file per talk.
- `_publications/` contains papers and patents.
- `_templates/` contains ready-to-copy front matter for new entries.
- `files/` contains locally hosted PDFs and other downloads.
- `images/profile.png` is the profile photo.

Dates determine display order. Keep explicit `permalink` values stable after an entry is published so existing links continue to work. External resource links open in a new tab.

## Presentation

Talks and publications share `_includes/timeline-entry.html` and `_sass/_timeline.scss`. Site-wide settings and profile links live in `_config.yml`; header navigation lives in `_data/navigation.yml`.

The checked-in `assets/js/main.min.js` is sufficient for normal content work. Node is only needed when changing the theme JavaScript; in that case, run `npm install` followed by `npm run build:js`.
