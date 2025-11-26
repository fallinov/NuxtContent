<script setup lang="ts">
const supabase = useSupabaseClient()

// État des filtres
const search = ref('')
const filter = ref('all') // 'all', 'completed', 'open'

// Interface pour les tâches
interface Task {
  id: string
  libelle: string
  date_creation: string
  date_fin: string | null
  terminee: boolean
}

// Chargement des données
const { data: tasks, pending, error, refresh } = await useAsyncData<Task[]>('tasks', async () => {
  const { data } = await supabase
    .from('taches')
    .select('*')
    .order('date_creation', { ascending: false })
  return (data as Task[]) || []
})

// Copie locale pour la réactivité temps réel
const localTasks = ref<Task[]>([])

// Synchroniser les données initiales et les rafraîchissements
watch(tasks, (newTasks) => {
  if (newTasks) {
    localTasks.value = [...newTasks]
  }
}, { immediate: true })

// Options pour le filtre
const filterOptions = [
  { label: 'Toutes', value: 'all' },
  { label: 'Terminées', value: 'completed' },
  { label: 'Ouvertes', value: 'open' }
]

// Options de tri
const sortOptions = [
  { label: 'Nom', value: 'libelle' },
  { label: 'Date', value: 'date' },
  { label: 'État', value: 'etat' }
]

const sortBy = ref('libelle')

// Filtrage et Tri côté client (sur localTasks)
const filteredTasks = computed(() => {
  const currentTasks = localTasks.value || []

  // 1. Filtrage
  const filtered = currentTasks.filter(task => {
    // Filtre par texte (insensible à la casse)
    const matchesSearch = task.libelle.toLowerCase().includes(search.value.toLowerCase())

    // Filtre par état
    const matchesFilter =
      filter.value === 'all' ||
      (filter.value === 'completed' && task.terminee) ||
      (filter.value === 'open' && !task.terminee)

    return matchesSearch && matchesFilter
  })

  // 2. Tri
  return filtered.sort((a, b) => {
    if (sortBy.value === 'libelle') {
      return a.libelle.localeCompare(b.libelle)
    } else if (sortBy.value === 'date') {
      return new Date(b.date_creation).getTime() - new Date(a.date_creation).getTime()
    } else if (sortBy.value === 'etat') {
      // Ouvertes avant Terminées
      return Number(a.terminee) - Number(b.terminee)
    }
    return 0
  })
})

// Mise à jour de l'état d'une tâche (déclenché par v-model)
const onTaskChange = async (task: Task) => {
  // task.terminee est déjà mis à jour par v-model
  const newStatus = task.terminee
  
  // Mise à jour locale de la date de fin
  task.date_fin = newStatus ? new Date().toISOString() : null

  const updates = {
    terminee: newStatus,
    date_fin: task.date_fin
  }

  const { error } = await (supabase
    .from('taches') as any)
    .update(updates)
    .eq('id', task.id)

  if (error) {
    console.error('Erreur lors de la mise à jour', error)
    // Revert en cas d'erreur
    refresh()
  }
}

// Realtime Subscription
let realtimeChannel: any

onMounted(() => {
  realtimeChannel = supabase
    .channel('public:taches')
    .on(
      'postgres_changes',
      { event: '*', schema: 'public', table: 'taches' },
      (payload) => {
        console.log('Realtime event:', payload) // Debug log
        
        if (payload.eventType === 'INSERT') {
          localTasks.value.unshift(payload.new as Task)
        } else if (payload.eventType === 'UPDATE') {
          const index = localTasks.value.findIndex(t => t.id === payload.new.id)
          if (index !== -1) {
            localTasks.value[index] = payload.new as Task
          }
        } else if (payload.eventType === 'DELETE') {
          localTasks.value = localTasks.value.filter(t => t.id !== payload.old.id)
        }
      }
    )
    .subscribe()
})

onUnmounted(() => {
  if (realtimeChannel) {
    supabase.removeChannel(realtimeChannel)
  }
})
</script>

<template>
  <UContainer class="py-8">
    <div class="flex flex-col gap-6">
      <div class="flex justify-between items-center">
        <h1 class="text-3xl font-bold">Gestion des Tâches</h1>
        <UButton
          icon="i-heroicons-arrow-path"
          color="neutral"
          variant="ghost"
          :loading="pending"
          @click="() => refresh()"
        >
          Actualiser
        </UButton>
      </div>

      <!-- Filtres -->
      <UCard>
        <div class="flex flex-col sm:flex-row gap-4">
          <UInput
            v-model="search"
            icon="i-heroicons-magnifying-glass"
            placeholder="Rechercher une tâche..."
            class="flex-1"
          />
          <div class="flex gap-2">
            <USelect
              v-model="sortBy"
              :items="sortOptions"
              class="w-40"
            />
            <UButton
              v-for="option in filterOptions"
              :key="option.value"
              :color="filter === option.value ? 'primary' : 'neutral'"
              :variant="filter === option.value ? 'solid' : 'ghost'"
              @click="filter = option.value"
            >
              {{ option.label }}
            </UButton>
          </div>
        </div>
      </UCard>

      <!-- Liste des tâches -->
      <div v-if="error" class="text-red-500">
        Une erreur est survenue lors du chargement des tâches.
      </div>

      <div v-else class="grid gap-4">
        <UCard v-for="task in filteredTasks" :key="task.id">
          <div class="flex items-start justify-between">
            <div class="flex items-start gap-3">
              <UCheckbox
                v-model="task.terminee"
                @change="onTaskChange(task)"
                class="mt-1"
              />
              <div>
                <h3
                  class="text-lg font-semibold"
                  :class="{ 'line-through text-gray-500': task.terminee }"
                >
                  {{ task.libelle }}
                </h3>
                <div class="text-sm text-gray-500 mt-1">
                  Créée le : {{ new Date(task.date_creation).toLocaleDateString() }}
                  <span v-if="task.date_fin">
                    • Terminée le : {{ new Date(task.date_fin).toLocaleDateString() }}
                  </span>
                </div>
              </div>
            </div>
            <UBadge :color="task.terminee ? 'success' : 'warning'">
              {{ task.terminee ? 'Terminée' : 'Ouverte' }}
            </UBadge>
          </div>
        </UCard>

        <div v-if="filteredTasks.length === 0" class="text-center text-gray-500 py-8">
          Aucune tâche trouvée.
        </div>
      </div>
    </div>
  </UContainer>
</template>
