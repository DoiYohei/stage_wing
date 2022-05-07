import Vue from "vue";
import Router from "vue-router";
import store from "@/store";
import Home from "@/views/Home";
import SignupBands from "@/views/Auth/SignupBands";
import SignupAudiences from "@/views/Auth/SignupAudiences";
import Login from "@/views/Auth/Login";
import EventsIndex from "@/views/Events/EventsIndex";
import EventsShow from "@/views/Events/EventsShow";
import EventsEdit from "@/views/Events/EventsEdit";
import EventsLineupsEdit from "@/views/Events/EventsLineupsEdit";
import EventsNew from "@/views/Events/EventsNew";
import BandsIndex from "@/views/Bands/BandsIndex";
import BandsShow from "@/views/Bands/BandsShow";
import BandsEdit from "@/views/Bands/BandsEdit";
import BandsTickets from "@/views/Bands/BandsTickets";
import BandsPostsNew from "@/views/Bands/BandsPostsNew";
import BandsFriends from "@/views/Bands/BandsFriends";
import ChatsIndex from "@/views/Chats/ChatsIndex";
import ChatsShow from "@/views/Chats/ChatsShow";
import AudiencesEdit from "@/views/Audiences/AudiencesEdit";
import AudiencesTickets from "@/views/Audiences/AudiencesTickets";
import AuthError from "@/views/Auth/AuthError";
import LikesIndex from "@/views/Likes/LikesIndex";

Vue.use(Router);

const redirectWithToken = () => {
  if (store.getters.token) return "/";
};

export default new Router({
  mode: "history",
  routes: [
    {
      path: "/",
      name: "Home",
      component: Home,
    },
    {
      path: "/signup/bands",
      name: "SignupBands",
      component: SignupBands,
      beforeEnter(to, from, next) {
        next(redirectWithToken());
      },
    },
    {
      path: "/signup/audiences",
      name: "SignupAudiences",
      component: SignupAudiences,
      beforeEnter(to, from, next) {
        next(redirectWithToken());
      },
    },
    {
      path: "/login",
      name: "Login",
      component: Login,
      beforeEnter(to, from, next) {
        next(redirectWithToken());
      },
    },
    {
      path: "/events/new",
      name: "EventsNew",
      component: EventsNew,
      beforeEnter(to, from, next) {
        store.getters.userType !== "bands" ? next("/") : next();
      },
    },
    {
      path: "/events",
      name: "EventsIndex",
      component: EventsIndex,
    },
    {
      path: "/events/:id",
      name: "EventsShow",
      component: EventsShow,
      props: true,
    },
    {
      path: "/events/:id/edit",
      name: "EventsEdit",
      component: EventsEdit,
      props: true,
    },
    {
      path: "/events/:id/lineup/edit",
      name: "EventsLineupsEdit",
      component: EventsLineupsEdit,
      props: true,
    },
    {
      path: "/bands",
      name: "BandsIndex",
      component: BandsIndex,
    },
    {
      path: "/bands/:id",
      name: "BandsShow",
      component: BandsShow,
      props: true,
    },
    {
      path: "/bands/:id/edit",
      name: "BandsEdit",
      component: BandsEdit,
      props: true,
    },
    {
      path: "/bands/:id/tickets",
      name: "BandsTickets",
      component: BandsTickets,
      props: true,
    },
    {
      path: "/bands/:id/posts/new",
      name: "BandsPostsNew",
      component: BandsPostsNew,
      props: true,
    },
    {
      path: "/bands/:id/friends",
      name: "BandsFriends",
      component: BandsFriends,
      props: true,
    },
    {
      path: "/bands/:id/chats",
      name: "ChatsIndex",
      component: ChatsIndex,
      props: true,
    },
    {
      path: "/bands/:bandId/chats/:roomId",
      name: "ChatsShow",
      component: ChatsShow,
      props: true,
    },
    {
      path: "/liked_posts",
      name: "LikesIndex",
      component: LikesIndex,
      beforeEnter(to, from, next) {
        !store.getters.token ? next("/") : next();
      },
    },
    {
      path: "/audiences/:id/edit",
      name: "AudiencesEdit",
      component: AudiencesEdit,
      props: true,
    },
    {
      path: "/audiences/:id/tickets",
      name: "AudiencesTickets",
      component: AudiencesTickets,
      props: true,
    },
    {
      path: "/auth/error",
      name: "AuthError",
      component: AuthError,
    },
  ],
});
