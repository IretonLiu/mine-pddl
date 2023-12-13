import os

import cv2
import numpy as np


class VideoHelper:
    def __init__(self, filepath: str) -> None:
        self.filepath = filepath
        self.image_count = 0

        # make sure there isn't a trailing slash
        if self.filepath[-1] == "/":
            self.filepath = self.filepath[:-1]

        os.makedirs(self.filepath, exist_ok=True)

    def save_image(self, rgb_image):
        """
        take in an array with rgb values, and save to file
        """
        filename = f"{self.filepath}/{self.image_count}.png"

        # save the image in BGR
        # file format will be chosen based on the file name
        cv2.imwrite(filename, np.transpose(rgb_image, (1, 2, 0))[:, :, ::-1])

        self.image_count += 1

    def generate_video(self, video_name: str):
        # setting the frame width, height width
        # the width, height of first image
        frame = cv2.imread(os.path.join(self.filepath, "0.png"))
        height, width, layers = frame.shape

        fourcc = cv2.VideoWriter_fourcc(*"mp4v")
        fps = 2
        video = cv2.VideoWriter(
            os.path.join(self.filepath, video_name), fourcc, fps, (width, height)
        )

        # Appending the images to the video one by one
        # add a pseudo-freeze frame at the end
        for i in range(self.image_count + 5):
            num = min(i, self.image_count - 1)
            video.write(cv2.imread(os.path.join(self.filepath, f"{num}.png")))

        # Deallocating memories taken for window creation
        cv2.destroyAllWindows()
        video.release()  # releasing the video generated

        print(f"Video saved to {os.path.join(self.filepath, video_name)}")

    def clean_up(self):
        # delete all the intermediate images
        for i in range(self.image_count):
            os.remove(os.path.join(self.filepath, f"{i}.png"))

        self.image_count = 0
