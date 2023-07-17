import router from "@/routes";

export const reloadPage = () => {
  router.go({ path: router.currentRoute.path, force: true });
};

export const goHome = () => {
  router.replace("/");
};

export const goTo401 = () => {
  router.replace("/errors/unauthorized");
};

export const goTo404 = () => {
  router.replace("/errors/not_found");
};
