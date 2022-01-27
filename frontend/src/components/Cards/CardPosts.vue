<template>
  <v-card flat>
    <v-card-text>
      <v-img v-if="post.format === 'photo'" :src="post.photo.url" />
      <vuetify-audio v-if="post.format === 'audio'" :file="post.audio.url" />
      <iframe
        v-if="post.format === 'soundcloud'"
        :src="`https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/${post.media_pass}`"
        width="50%"
        height="166"
        scrolling="no"
        frameborder="no"
      />
      <youtube v-if="post.format === 'youtube'" :video-id="post.media_pass" />
    </v-card-text>
    <v-card-subtitle class="d-flex align-center">
      {{ $dayjs(post.created_at).format("YYYY MMM DD") }}
      <v-btn @click="orderChange" icon class="mx-4">
        <v-icon :color="post.favorite ? 'red' : 'grey'" small>
          {{ post.favorite ? "mdi-heart" : "mdi-heart-outline" }}
        </v-icon>
        {{ post.likes_count }}
      </v-btn>
      <v-menu v-if="isMyPage">
        <template v-slot:activator="{ on, attrs }">
          <v-btn icon v-bind="attrs" v-on="on">
            <v-icon>mdi-dots-horizontal</v-icon>
          </v-btn>
        </template>
        <v-card-text class="pa-0">
          <v-list>
            <v-list-item-group>
              <v-list-item @click="editable = true">編集する</v-list-item>
              <v-dialog v-model="dialog" width="45vw">
                <template #activator="{ on, attrs }">
                  <v-list-item v-bind="attrs" v-on="on">削除する</v-list-item>
                </template>
                <CardDialog
                  dialogText="この投稿を削除しますか？"
                  :select-excution="orderDelete"
                  :select-cancel="closeDialog"
                />
              </v-dialog>
            </v-list-item-group>
          </v-list>
        </v-card-text>
      </v-menu>
    </v-card-subtitle>
    <v-card-text>
      <span v-if="!editable" class="reflect-return">
        {{ post.description }}
      </span>
      <template v-if="editable">
        <v-textarea
          v-model="post.description"
          label="内容"
          auto-grow
          autofocus
          hide-details
          outlined
        />
        <v-card-actions class="d-flex justify-end">
          <v-btn @click="editable = false">キャンセル</v-btn>
          <v-btn @click="orderPatch">変更する</v-btn>
        </v-card-actions>
      </template>
    </v-card-text>
    <v-divider />
  </v-card>
</template>

<script>
import CardDialog from "@/components/Cards/CardDialog";

export default {
  name: "CardPosts",
  components: {
    CardDialog,
  },
  props: {
    post: {
      type: Object,
      required: true,
    },
    isMyPage: {
      type: Boolean,
      required: true,
    },
    deletePost: {
      type: Function,
      required: true,
    },
    patchPost: {
      type: Function,
      required: true,
    },
    changeLike: {
      type: Function,
      required: true,
    },
  },
  data() {
    return {
      dialog: false,
      editable: false,
    };
  },
  methods: {
    orderDelete() {
      this.deletePost(this.post.id);
    },
    orderPatch() {
      this.patchPost(this.post.id, this.post.description);
      this.editable = false;
    },
    orderChange() {
      this.changeLike(this.post);
    },
    closeDialog() {
      this.dialog = false;
    },
  },
};
</script>
