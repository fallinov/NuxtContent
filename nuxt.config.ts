// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },
  modules: ['@nuxt/content', '@nuxt/ui', 'nuxt-studio', '@nuxtjs/supabase'],
  supabase: {
    redirect: false
  },
  css: ['~/assets/css/main.css'],
  content: {
    database: {
      type: 'postgres',
      url: process.env.POSTGRES_URL || process.env.DATABASE_URL || ''
    }
  }
})