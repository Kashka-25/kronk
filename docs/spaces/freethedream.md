# FreeTheDream (`freethedream` — prototype)

**Manifest:** `config/korners/freethedream.yaml` · **Mount:** `/hub/freethedream` ·
`enforced: false` (iframe prototype)

## Purpose

FreeTheDream is **the Dream Web**: a map of community dreams around
FreeTheDream, the philosophy at its heart. We're here to help free each
other's dreams. The map is the "O" from the YOU logo: the ocean side is each
person's inner life, the cosmos side (in Kronk's purples) is the shared life
of the community.

Source: [`Kashka-25/free-the-dream-map`](https://github.com/Kashka-25/free-the-dream-map).

## What it does

- **The Dream Web grows by approval.** It starts with only FreeTheDream at
  the heart. A dream joins once an admin approves it, and the person who
  shared it runs it.
- **Guidelines.** A dream belongs on the web if it involves the community in
  some shape or form. Personal dreams are pointed to YOU; simple messages and
  posts to the Kronk feed.
- **Share a dream.** One question first, "Who is this dream for?", then a
  short form that asks how the community is involved.
- **Run your dream.** Whoever runs a project fills in its tagline, about,
  its part in the dream, how to get involved, reflections, open questions and
  logo, in place.
- **Review** (admins). Approve or decline shared dreams and requests to run
  a project; add the founding projects (Kronk, Organisation, YOU, Anthemos,
  CommYOUnity, Mayhem, SoulRise, Space, Empatherapy, The $2 Push) one at a
  time.
- **How it works.** A seven-step tour that opens on a first visit.

## What is built

- **Prototype** — `public/freethedream-preview.html`, a single
  self-contained file (images embedded), rendered at `/hub/freethedream`
  by `FreeTheDream` (`app/javascript/mastodon/features/freethedream/index.tsx`)
  through `KornerIframe`.
- **In this preview everything is local.** Each viewer is the admin of
  their own copy, the web starts empty, and anything they add stays in their
  browser. Review → Our projects adds the founding projects.
- **Manifest** — no resources, tables, permissions or feed card yet.
  Icon `spiral`. Node `freethedream.index`, `lifecycle: soon`.

## Making it shared: Kronk accounts as members

The map already has a Kronk backend. Setting this before its script runs
turns it on:

```html
<script>
  window.FTD_CONFIG = {
    backend: 'kronk',
    api: '/api/v1/freethedream',
    csrfToken: '…',
  };
</script>
```

**Members are Kronk accounts** — no separate sign-up. Names come from
Kronk, and Kronk decides who the map's admins are (stewards, or a Krew).

It needs four JSON endpoints, same-origin with the session cookie:

| Method | Path          | Who                           | Response / body                                                      |
| ------ | ------------- | ----------------------------- | -------------------------------------------------------------------- |
| `GET`  | `/me`         | anyone                        | `{ "id": "109", "admin": false }`; `401` when signed out (read-only) |
| `GET`  | `/state`      | anyone who can see the korner | `{ members: {id: doc}, map: {docId: doc}, names: {id: "Sam"} }`      |
| `PUT`  | `/members/me` | signed-in accounts            | the viewer's own document, replaced whole                            |
| `PUT`  | `/map/:docId` | admins only (`403` otherwise) | one map document, replaced whole                                     |

Two kinds of JSON document: `members/<account id>` (written only by that
person: the dreams they shared, requests to run a project, project edits and
logos) and `map/<doc>` (admin-only: approved projects, review decisions, who
runs what, admin edits and logos). The page trusts a person's project edits
only if `map/stewards` lists them for that project.

Full data shapes, how a fresh server gets its founding projects, and how to
copy data across from the Claude-hosted version: `KRONK.md` in the source
repo. `kronk-sim/server.py` there is a ~150-line reference server for the
four endpoints, with pretend accounts to try the shared flow locally.

## Deferred

- **The four endpoints** above, and flipping the preview to
  `backend: "kronk"`.
- **A Kommons proposal** for the korner, per `docs/korners/adding_a_korner.md`.
- **A native port** — the Standard's layers (KornerShell, feed projection,
  settings) once the shape is agreed.
- **Krews and Nudges** — the people of a project as a Krew, project news as
  Nudges.

## History

Added 2026-10-06 as an iframe prototype so it can be seen on shadow.
Updated 2026-10-07 to the Dream Web: grows by approval, guidelines, Share a
dream, How it works.
