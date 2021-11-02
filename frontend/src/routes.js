import Vue from "vue";
import Router from "vue-router";
import Home from "@/views/Home";
import SignUp from "@/views/Auth/SignUp";
import LogIn from "@/views/Auth/LogIn";
import EventsIndex from "@/views/Events/EventsIndex";
import EventsShow from "@/views/Events/EventsShow";
import EventsEdit from "@/views/Events/EventsEdit";
import LineupEdit from "@/views/Events/LineupEdit";
import EventsNew from "@/views/Events/EventsNew";
import BandsIndex from "@/views/Bands/BandsIndex";
import BandsShow from "@/views/Bands/BandsShow";
import BandsEdit from "@/views/Bands/BandsEdit";
import PostsIndex from "@/views/Posts/PostsIndex";
import PostsNew from "@/views/Posts/PostsNew";
import PostsEdit from "@/views/Posts/PostsEdit";
import Friendships from "@/views/Friendships";
import ChatsIndex from "@/views/Chats/ChatsIndex";
import ChatsShow from "@/views/Chats/ChatsShow";
import AudiencesShow from "@/views/Audiences/AudiencesShow";
import AudiencesEdit from "@/views/Audiences/AudiencesEdit";

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
      path: "/signup",
      name: "SignUp",
      component: SignUp,
    },
    {
      path: "/login",
      name: "LogIn",
      component: LogIn,
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
      name: "LineupEdit",
      component: LineupEdit,
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
    },
    {
      path: "/bands/:id/edit",
      name: "BandsEdit",
      component: BandsEdit,
      props: true,
    },
    {
      path: "/bands/:id/posts",
      name: "PostsIndex",
      component: PostsIndex,
      props: true,
    },
    {
      path: "/bands/:id/posts/new",
      name: "PostsNew",
      component: PostsNew,
      props: true,
    },
    {
      path: "/bands/:id/posts/:postId/edit",
      name: "PostsEdit",
      component: PostsEdit,
      props: true,
    },
    {
      path: "/bands/:id/friendships",
      name: "Friendships",
      component: Friendships,
      props: true,
    },
    {
      path: "/bands/:id/chats",
      name: "ChatsIndex",
      component: ChatsIndex,
      props: true,
    },
    {
      path: "/bands/:id/chats/:room_id",
      name: "ChatsShow",
      component: ChatsShow,
      props: true,
    },
    {
      path: "/audiences/:userId",
      name: "AudiencesShow",
      component: AudiencesShow,
      props: true,
    },
    {
      path: "/audiences/:userId/edit",
      name: "AudiencesEdit",
      component: AudiencesEdit,
      props: true,
    },
  ],
});
