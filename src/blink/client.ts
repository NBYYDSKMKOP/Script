import { createClient } from '@blinkdotnew/sdk'

export const blink = createClient({
  projectId: import.meta.env.VITE_BLINK_PROJECT_ID || 'atomic-php-website-jlw4mqln',
  publishableKey: import.meta.env.VITE_BLINK_PUBLISHABLE_KEY || 'blnk_pk_6K_0z1oLT0mKr0qJ0Xf5W2-LQl046p7o',
  authRequired: false,
  auth: { mode: 'managed' },
})
