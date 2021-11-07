import { createWebHistory, createRouter } from "vue-router";
import Rushings from "@/components/Rushings.vue";

const routes = [
  { path: "/", name: "Home", component: Rushings, props: true }
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
