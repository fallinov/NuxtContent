# Nuxt Content v3 Starter

Ce projet est un starter minimaliste et performant utilisant les dernières technologies de l'écosystème Nuxt. Il est configuré pour être déployé sur Vercel avec une persistance des données via Supabase (PostgreSQL).

## 🚀 Fonctionnalités

*   **Framework** : [Nuxt 4](https://nuxt.com)
*   **Contenu** : [Nuxt Content v3](https://content.nuxt.com) (Architecture SQL)
*   **UI** : [Nuxt UI v4](https://ui.nuxt.com) (Tailwind CSS v4)
*   **CMS** : [Nuxt Studio](https://nuxt.studio) (Édition visuelle Git-based)
*   **Base de données** : [Supabase](https://supabase.com) (PostgreSQL) pour le SSR sur Vercel.
*   **SEO** : Méta-données dynamiques et support des mots-clés.

## 📋 Prérequis

*   Node.js (v18+)
*   Un compte [Supabase](https://supabase.com) (pour la production)
*   Un compte [Vercel](https://vercel.com) (pour le déploiement)

## 🛠️ Installation

1.  Clonez le dépôt :
    ```bash
    git clone <votre-repo-url>
    cd <votre-repo-nom>
    ```

2.  Installez les dépendances :
    ```bash
    npm install
    ```

## 💻 Développement Local

Pour lancer le serveur de développement :

```bash
npm run dev
```

Ouvrez [http://localhost:3000](http://localhost:3000) dans votre navigateur.

### Nuxt Studio (Local)
Pour éditer votre contenu localement avec une interface visuelle :
1.  Lancez le serveur de dev (`npm run dev`).
2.  Ouvrez les **Nuxt DevTools** (`Shift + Alt + D` ou icône en bas).
3.  Allez dans l'onglet **Studio**.

## 🌍 Déploiement (Vercel)

Ce projet est configuré pour le **Rendu Côté Serveur (SSR)** sur Vercel. Comme Vercel est "stateless", nous utilisons Supabase pour stocker les données de contenu.

### Configuration Supabase
1.  Créez un projet sur Supabase.
2.  Récupérez votre **Connection String** (Transaction Pooler recommandé, port 6543).
    *   Format : `postgresql://postgres.[ref]:[password]@aws-0-[region].pooler.supabase.com:6543/postgres`

### Configuration Vercel
1.  Importez votre dépôt Git sur Vercel.
2.  Dans les **Environment Variables**, ajoutez :
    *   `POSTGRES_URL` : Votre chaîne de connexion Supabase.
3.  Déployez !
3.  Déployez !
4.  Exécutez le script SQL `supabase_schema.sql` dans l'éditeur SQL de Supabase pour créer la table `taches` et activer le Realtime.

## 📝 Fonctionnalités Détailées

### Gestion des Tâches
*   **Page** : `/taches`
*   **Fonctionnalités** :
    *   Liste des tâches depuis Supabase.
    *   **Temps Réel** : Mises à jour instantanées (ajout, modif, suppression) via Supabase Realtime.
    *   **Filtres** : Toutes, Terminées, Ouvertes.
    *   **Tri** : Par Nom, Date ou Statut.
    *   **Recherche** : Filtrage textuel instantané.


Pour comprendre le fonctionnement interne, le flux de données et la différence entre le rendu local (SQLite) et production (PostgreSQL), consultez la documentation détaillée :

👉 [**Architecture et Fonctionnement**](_docs/fonctionnement.md)

## 📝 SEO

Le projet gère automatiquement :
*   Le titre de la page (`title`)
*   La description (`description`)
*   Les mots-clés (`keywords`)

Ajoutez simplement ces champs dans le frontmatter de vos fichiers Markdown (`content/blog/*.md`).
