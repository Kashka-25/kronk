import { defineMessages, useIntl } from 'react-intl';

import { KornerIframe } from 'mastodon/components/korner_iframe';

// FreeTheDream — a collective mind map of the community's projects
// (YOU, Kronk, Anthemos, Mayhem, SoulRise, Empatherapy, CommYOUnity …)
// on the YOU yin-yang. Ships Kashka's self-contained prototype from
// `public/freethedream-preview.html` (source: Kashka-25/free-the-dream-map).
// In this preview each person's additions stay in their own browser;
// the shared version talks to four JSON endpoints using Kronk accounts —
// see `docs/spaces/freethedream.md`.

const messages = defineMessages({
  title: { id: 'freethedream.title', defaultMessage: 'FreeTheDream' },
});

const FreeTheDream: React.FC<{ multiColumn?: boolean }> = () => {
  const intl = useIntl();
  return (
    <KornerIframe
      title={intl.formatMessage(messages.title)}
      src='/freethedream-preview.html'
    />
  );
};

// eslint-disable-next-line import/no-default-export
export default FreeTheDream;
