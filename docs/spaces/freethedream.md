# FreeTheDream (`freethedream` — prototype)

**Manifest:** `config/korners/freethedream.yaml` · **Mount:** `/hub/freethedream` ·
`enforced: false` (iframe prototype)

## Purpose

FreeTheDream is a **collective mind map** of the community's projects: how
YOU, Kronk, Anthemos, Mayhem, SoulRise, Empatherapy, CommYOUnity, the Space
and the Organisation connect, and how new ideas join them. The map is the
"O" from the YOU logo: the ocean side is each person's inner life, the
cosmos side (in Kronk's purples) is the shared life of the community.

The vision behind it: a system where people are rewarded for following
their passions and for making the world a better place: heART.

Source: [`Kashka-25/free-the-dream-map`](https://github.com/Kashka-25/free-the-dream-map).

## What it does

- **Two views** — a golden spiral through every project, and a web of
  influence with every link drawn. Opening a project sends a ripple
  through its connections.
- **Projects start empty.** Whoever runs a project fills in its tagline,
  about, its part in the dream, how to get involved, reflections, open
  questions and logo, in place.
- **Idea drop** — anyone drops an idea into a shared pool; an admin
  approves it onto the map as a new project, run by the person who
  dropped it.
- **Review** — admins approve ideas and requests to run a project, and
  manage who runs what.

## What is built

- **Prototype** — `public/freethedream-preview.html`, a single
  self-contained file (images embedded), rendered at `/hub/freethedream`
  by `FreeTheDream` (`app/javascript/mastodon/features/freethedream/index.tsx`)
  through `KornerIframe`.
- **In this preview everything is local.** Each viewer is the admin of
  their own copy and anything they add stays in their browser.
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
person: their dropped ideas, requests to run a project, project edits and
logos) and `map/<doc>` (admin-only: approved projects, review decisions,
who runs what, admin edits and logos). The page trusts a person's project
edits only if `map/stewards` lists them for that project. Data shapes and
a suggested Rails approach (one table of JSON documents plus permission
checks): `KRONK.md` in the source repo.

## Deferred

- **The four endpoints** above, and flipping the preview to
  `backend: "kronk"`.
- **A Kommons proposal** for the korner, per `docs/korners/adding_a_korner.md`.
- **A native port** — the Standard's layers (KornerShell, feed projection,
  settings) once the shape is agreed.
- **Krews and Nudges** — project membership as Krews, project news as
  Nudges.

## History

Added 2026-10-06 as an iframe prototype so it can be seen on shadow.
