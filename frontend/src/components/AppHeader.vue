<template>
  <v-app-bar fixed hide-on-scroll>
    <v-toolbar-title>
      <router-link to="/">Stage Wing</router-link>
    </v-toolbar-title>
    <v-spacer />
    <router-link to="/events">Event</router-link>
    <router-link to="/bands">Band</router-link>
    <v-spacer />
    <template v-if="!token">
      <router-link to="/signup/bands">Sign Up As Bands</router-link>
      <router-link to="/signup/audiences">Sign Up As Audiences</router-link>
      <router-link to="/login">Log In</router-link>
    </template>
    <v-menu v-if="token" left bottom>
      <template #activator="{ on, attrs }">
        <v-avatar v-bind="attrs" v-on="on" size="45">
          <v-img v-if="avatar" :src="avatar" />
          <v-img v-if="!avatar" src="@/assets/img/no_avatar.jpeg" />
        </v-avatar>
      </template>
      <v-list class="text-left">
        <template v-if="isAuthenticatedBand">
          <v-list-item :to="`/bands/${userId}`">
            <v-list-item-title>My Page</v-list-item-title>
          </v-list-item>
          <v-list-item :to="`/bands/${userId}/edit`">
            <v-list-item-title>アカウント情報を編集する</v-list-item-title>
          </v-list-item>
        </template>
        <template v-if="isAuthenticatedAudience">
          <v-list-item :to="`/audiences/${userId}/edit`">
            <v-list-item-title>アカウント情報を編集する</v-list-item-title>
          </v-list-item>
          <v-list-item to="/liked_posts">
            <v-list-item-title>お気に入り</v-list-item-title>
          </v-list-item>
          <v-list-item :to="`/audiences/${userId}/tickets`">
            <v-list-item-title>取り置きしているチケット</v-list-item-title>
          </v-list-item>
        </template>
        <v-dialog v-model="dialog" width="45vw">
          <template #activator="{ on, attrs }">
            <v-list-item v-bind="attrs" v-on="on">
              <v-list-item-title>Log Out</v-list-item-title>
            </v-list-item>
          </template>
          <CardDialog
            dialog-text="ログアウトしますか？"
            :select-excution="logout"
            :select-cancel="closeDialog"
          />
        </v-dialog>
      </v-list>
    </v-menu>
  </v-app-bar>
</template>

<script>
import { mapGetters } from "vuex";
import { mapActions } from "vuex";
import CardDialog from "@/components/Cards/CardDialog";

export default {
  components: {
    CardDialog,
  },
  data() {
    return {
      dialog: 0,
    };
  },
  computed: {
    ...mapGetters([
      "token",
      "avatar",
      "isAuthenticatedBand",
      "isAuthenticatedAudience",
      "userId",
    ]),
  },
  methods: {
    ...mapActions(["logout"]),
    closeDialog() {
      this.dialog = false;
    },
  },
};
</script>
