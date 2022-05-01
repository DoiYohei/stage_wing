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
        :to="content.link"
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
          <CardDialog
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
          <CardDialog
            dialog-text="退会しますか？"
            @select-excution="closeAccount"
            @close-dialog="closeDialog"
          />
        </v-dialog>
      </template>
    </v-list>
  </v-navigation-drawer>
</template>

<script>
import { mapGetters } from "vuex";
import { mapActions } from "vuex";
import CardDialog from "@/components/Cards/CardDialog";

export default {
  components: {
    CardDialog,
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
    this.fetchList();
  },
  computed: {
    ...mapGetters([
      "isAuthenticatedBand",
      "isAuthenticatedAudience",
      "token",
      "userId",
      "userName",
      "userImage",
    ]),
    drawer: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
  },
  watch: {
    token() {
      this.fetchList();
    },
  },
  methods: {
    ...mapActions(["logout", "deleteAccount"]),
    logOut() {
      this.logout();
      this.closeDialog();
    },
    closeAccount() {
      this.deleteAccount();
      this.closeDialog();
    },
    closeDialog() {
      this.logoutDialog = false;
      this.deleteDialog = false;
    },
    fetchList() {
      if (this.isAuthenticatedBand) {
        this.contents = [
          {
            text: "マイページ",
            link: {
              name: "BandsShow",
              params: {
                id: this.userId,
              },
            },
          },
          {
            text: "新規Event作成",
            link: {
              name: "EventsNew",
            },
          },
          {
            text: "新規Post作成",
            link: {
              name: "BandsPostsNew",
              params: {
                id: this.userId,
              },
            },
          },
          {
            text: "Friendリスト",
            link: {
              name: "BandsFriends",
              params: {
                id: this.userId,
              },
            },
          },
          {
            text: "チャット",
            link: {
              name: "ChatsIndex",
              params: {
                id: this.userId,
              },
            },
          },
          {
            text: "チケット取り置き状況",
            link: {
              name: "BandsTickets",
              params: {
                id: this.userId,
              },
            },
          },
          {
            text: "お気に入り",
            link: {
              name: "LikesIndex",
            },
          },
          {
            text: "アカウント編集",
            link: {
              name: "BandsEdit",
              params: {
                id: this.userId,
              },
            },
          },
        ];
      } else if (this.isAuthenticatedAudience) {
        this.contents = [
          {
            text: "取り置きしているチケット",
            link: {
              name: "AudiencesTickets",
              params: {
                id: this.userId,
              },
            },
          },
          {
            text: "お気に入り",
            link: {
              name: "LikesIndex",
            },
          },
          {
            text: "アカウント編集",
            link: {
              name: "AudiencesEdit",
              params: {
                id: this.userId,
              },
            },
          },
        ];
      } else {
        this.contents = [
          {
            text: "アカウント作成 (アーティスト)",
            link: {
              name: "SignupBands",
            },
          },
          {
            text: "アカウント作成 (一般の方)",
            link: {
              name: "SignupAudiences",
            },
          },
          {
            text: "ログイン",
            link: {
              name: "Login",
            },
          },
        ];
      }
    },
  },
};
</script>
