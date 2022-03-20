import Vue from "vue";
import Router from "vue-router";
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
import BandsPostsIndex from "@/views/Bands/BandsPostsIndex";
import BandsEvents from "@/views/Bands/BandsEvents";
import BandsTickets from "@/views/Bands/BandsTickets";
import BandsPostsNew from "@/views/Bands/BandsPostsNew";
import BandsFriends from "@/views/Bands/BandsFriends";
import ChatsIndex from "@/views/Chats/ChatsIndex";
import ChatsShow from "@/views/Chats/ChatsShow";
import AudiencesEdit from "@/views/Audiences/AudiencesEdit";
import AudiencesTickets from "@/views/Audiences/AudiencesTickets";
import AuthError from "@/views/Errors/AuthError";
import LikesIndex from "@/views/Likes/LikesIndex";

Vue.use(Router);

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
    },
    {
      path: "/signup/audiences",
      name: "SignupAudiences",
      component: SignupAudiences,
    },
    {
      path: "/login",
      name: "Login",
      component: Login,
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
      path: "/event/new",
      name: "EventsNew",
      component: EventsNew,
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
      children: [
        {
          path: "posts",
          component: BandsPostsIndex,
          props: true,
        },
        {
          path: "events",
          component: BandsEvents,
          props: true,
        },
      ],
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
      path: "/errors/auth",
      name: "AuthError",
      component: AuthError,
    },
  ],
});
