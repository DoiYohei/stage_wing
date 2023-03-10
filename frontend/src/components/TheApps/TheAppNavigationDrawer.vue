<template>
  <v-navigation-drawer v-model="drawer" fixed right temporary>
    <v-list>
      <v-list-item>
        <v-list-item-avatar>
          <v-img :src="userImage" />
        </v-list-item-avatar>
        <v-list-item-content>
          <v-list-item-title v-text="token ? userName : '未ログイン'" />
        </v-list-item-content>
      </v-list-item>
      <v-divider class="mb-3" />
      <v-list-item
        v-for="(content, index) in contents"
        :key="index"
        :to="content.path"
      >
        <v-list-item-content>
          <v-list-item-title v-text="content.text" />
        </v-list-item-content>
      </v-list-item>
      <template v-if="token">
        <v-dialog v-model="logoutDialog" width="45vw">
          <template #activator="{ on, attrs }">
            <v-list-item v-bind="attrs" v-on="on">
              <v-list-item-content>
                <v-list-item-title>ログアウト</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </template>
          <DialogYesNo
            dialog-text="ログアウトしますか？"
            @select-excution="logOut"
            @close-dialog="closeDialog"
          />
        </v-dialog>
        <v-dialog v-model="deleteDialog" width="45vw">
          <template #activator="{ on, attrs }">
            <v-list-item v-bind="attrs" v-on="on">
              <v-list-item-content>
                <v-list-item-title>退会する</v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </template>
          <DialogYesNo
            dialog-text="退会しますか？"
            @select-excution="closeAccount"
            @close-dialog="closeDialog"
          />
        </v-dialog>
        <DialogShowText v-model="errorDialog">
          {{ errorMessage }}
        </DialogShowText>
      </template>
    </v-list>
  </v-navigation-drawer>
</template>

<script>
import { mapGetters } from "vuex";
import { mapActions } from "vuex";
import DialogYesNo from "@/components/Dialogs/DialogYesNo";
import DialogShowText from "@/components/Dialogs/DialogShowText";

export default {
  components: {
    DialogYesNo,
    DialogShowText,
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
      errorDialog: false,
      errorMessage: "",
    };
  },
  created() {
    this.fetchList();
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
      this.fetchList();
    },
    isXsDisplay(value) {
      if (value) {
        this.unshiftEventAndBand();
      } else {
        this.contents.splice(0, 2);
      }
    },
  },
  methods: {
    ...mapActions(["logout", "deleteAccount"]),
    async logOut() {
      const res = await this.logout();
      this.closeDialog(res);
    },
    async closeAccount() {
      const res = await this.deleteAccount();
      this.closeDialog(res);
    },
    closeDialog(message) {
      this.logoutDialog = false;
      this.deleteDialog = false;
      if (message) {
        this.errorMessage = message;
        this.errorDialog = true;
      }
    },
    fetchList() {
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
