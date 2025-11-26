<script setup lang="ts">
const { data: posts } = await useAsyncData('blog', () => {
  return queryCollection('blog').all()
})
</script>

<template>
  <UContainer class="py-8">
    <h1 class="text-3xl font-bold mb-8">Blog</h1>
    <div class="grid gap-4">
      <UCard v-for="post in posts" :key="post.path">
        <template #header>
          <h2 class="text-xl font-semibold">{{ post.title }}</h2>
        </template>
        <p>{{ post.description }}</p>
        <template #footer>
          <UButton :to="post.path" color="primary" variant="ghost">Read more</UButton>
        </template>
      </UCard>
    </div>
  </UContainer>
</template>
