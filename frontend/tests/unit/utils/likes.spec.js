import axios from "@/plugins/axios";
import store from "@/store";
import { changeLike } from "@/utils/likes";

jest.mock("@/plugins/axios");
store.commit("updateAuthData", {token: "token"});

describe("changeLike", () => {

  it("calls axios.delete when post.favorite is true", () => {
    const post = { id: 1, favorite: true, likes_count: 10 };
    changeLike(post);
    expect(axios.delete).toHaveBeenCalled();
    expect(post.favorite).toBe(false);
    expect(post.likes_count).toBe(9);
  });

  it("calls axios.post when post.favorite is false", () => {
    const post = { id: 1, favorite: false, likes_count: 10 };
    changeLike(post);
    expect(axios.post).toHaveBeenCalled();
    expect(post.favorite).toBe(true);
    expect(post.likes_count).toBe(11);
  });
});
