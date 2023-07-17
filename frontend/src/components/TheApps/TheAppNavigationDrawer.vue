<template>
  <v-navigation-drawer v-model="drawer" fixed right temporary>
    <v-list>
      <v-list-item>
        <v-list-item-avatar>
          <v-img :src="userImage" />
        </v-list-item-avatar>
        <v-list-item-content>
          <v-list-item-title>
            {{ token ? userName : "未ログイン" }}
          </v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <v-divider class="mb-3" />
      <v-list-item
        v-for="(content, index) in contents"
        :key="index"
        :to="content.path"
      >
        <v-list-item-content>
          <v-list-item-title>{{ content.text }}</v-list-item-title>
        </v-list-item-content>
      </v-list-item>
      <template v-if="token">
        <v-list-item @click.stop="logoutDialog = true">
          <v-list-item-content>
            <v-list-item-title>ログアウト</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <DialogYesNo
          v-model="logoutDialog"
          question="ログアウトしますか？"
          @select-excution="logOut"
          @close-dialog="closeLogoutDialog"
        />
        <v-list-item @click.stop="deleteDialog = true">
          <v-list-item-content>
            <v-list-item-title>退会する</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <DialogYesNo
          v-model="deleteDialog"
          question="退会しますか？"
          @select-excution="closeAccount"
          @close-dialog="closeDeleteDialog"
        />
      </template>
    </v-list>
  </v-navigation-drawer>
</template>

<script>
import DialogYesNo from "@/components/Dialogs/DialogYesNo";
import { mapGetters, mapActions } from "vuex";

export default {
  components: {
    DialogYesNo,
  },
  props: {
    value: {
      type: Boolean,
      require: true,
    },
  },
  data() {
    return {
      contents: [],
      logoutDialog: false,
      deleteDialog: false,
    };
  },
  created() {
    this.setUpContents();
  },
  computed: {
    ...mapGetters(["bandId", "audienceId", "token", "userName", "userImage"]),
    drawer: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
    isXsDisplay() {
      return this.$vuetify.breakpoint.xs;
    },
  },
  watch: {
    token() {
      this.setUpContents();
    },
    isXsDisplay(value) {
      return value ? this.unshiftEventAndBand() : this.contents.splice(0, 2);
    },
  },
  methods: {
    ...mapActions(["logout", "deleteAccount"]),
    async logOut() {
      await this.logout();
      this.closeLogoutDialog();
    },
    async closeAccount() {
      await this.deleteAccount();
      this.closeDeleteDialog();
    },
    closeLogoutDialog() {
      this.logoutDialog = false;
    },
    closeDeleteDialog() {
      this.deleteDialog = false;
    },
    setUpContents() {
      if (this.bandId) {
        this.contents = [
          {
            text: "マイページ",
            path: `/bands/${this.bandId}`,
          },
          {
            text: "新規Event作成",
            path: "/events/new",
          },
          {
            text: "新規Post作成",
            path: "/posts/new",
          },
          {
            text: "Friendリスト",
            path: `/bands/${this.bandId}/friends`,
          },
          {
            text: "チャット",
            path: `/bands/${this.bandId}/chats`,
          },
          {
            text: "チケット取り置き状況",
            path: `/bands/${this.bandId}/tickets`,
          },
          {
            text: "お気に入り",
            path: "/likes",
          },
          {
            text: "アカウント編集",
            path: `/bands/${this.bandId}/edit`,
          },
        ];
      } else if (this.audienceId) {
        this.contents = [
          {
            text: "取り置きしているチケット",
            path: `/audiences/${this.audienceId}/tickets`,
          },
          {
            text: "お気に入り",
            path: "/likes",
          },
          {
            text: "アカウント編集",
            path: `/audiences/${this.audienceId}/edit`,
          },
        ];
      } else {
        this.contents = [
          {
            text: "アカウント作成",
            path: "/signup",
          },
          {
            text: "ログイン",
            path: "/login",
          },
        ];
      }
      if (this.isXsDisplay) {
        this.unshiftEventAndBand();
      }
    },
    unshiftEventAndBand() {
      this.contents.unshift(
        {
          text: "EVENT",
          path: "/events",
        },
        {
          text: "BAND",
          path: "/bands",
        }
      );
    },
  },
};
</script>
