<script setup lang="ts">
const route = useRoute()
const { data: post } = await useAsyncData(route.path, () => {
  return queryCollection('blog').path(route.path).first()
})

useSeoMeta({
  title: post.value?.title,
  description: post.value?.description,
  keywords: post.value?.keywords?.join(', ')
})
</script>

<template>
  <UContainer class="py-8">
    <div v-if="post">
      <h1 class="text-3xl font-bold mb-4">{{ post.title }}</h1>
      <p class="text-gray-500 mb-8">{{ post.date }}</p>
      <ContentRenderer :value="post" />
    </div>
    <div v-else>
      <p>Post not found</p>
      <UButton to="/">Go back home</UButton>
    </div>
  </UContainer>
</template>
