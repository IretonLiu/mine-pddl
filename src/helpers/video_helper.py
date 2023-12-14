# type: ignore

import os

import cv2
import numpy as np


class VideoHelper:
    def __init__(
        self,
        filepath: str,
        task_name: str,
        domain_name: str,
        problem_name: str,
        pddl_type: str,
    ) -> None:
        self.filepath = filepath
        self.image_count = 0
        self.birds_eye_view_image_path = os.path.join(
            self.filepath, "birds_eye_view.png"
        )

        # make sure there isn't a trailing slash
        if self.filepath[-1] == "/":
            self.filepath = self.filepath[:-1]

        os.makedirs(self.filepath, exist_ok=True)

        # constrcu the text overlay message
        self.video_text_overlay = f"Task: {task_name}\nDomain: {domain_name}\nProblem: {problem_name}\nPDDL Type: {pddl_type}"

    def save_image(self, rgb_image):
        """
        take in an array with rgb values, and save to file
        """
        filename = f"{self.filepath}/{self.image_count}.png"

        # save the image in BGR
        # file format will be chosen based on the file name
        cv2.imwrite(
            filename,
            np.transpose(rgb_image, (1, 2, 0))[:, :, ::-1],
        )

        self.image_count += 1

    def save_birds_eye_view(self, rgb_image):
        """
        take in an array with rgb values, and save to file with a special name
        """
        # save the image in BGR
        # file format will be chosen based on the file name
        cv2.imwrite(
            self.birds_eye_view_image_path,
            np.transpose(rgb_image, (1, 2, 0))[:, :, ::-1],
        )

    def overlay_text(self, img):
        """
        overlay text on the image. the position ratio is in (width, height)
        """

        # https://stackoverflow.com/a/54234703/6812182
        text_array = self.video_text_overlay.split("\n")
        font_scale = 1
        colour = (0, 0, 0)
        thickness = 2
        font = cv2.FONT_HERSHEY_SIMPLEX
        line_type = cv2.LINE_AA
        position = (10, 50)

        text_size, _ = cv2.getTextSize(text_array[0], font, font_scale, thickness)
        line_height = text_size[1] + 5

        x, y0 = position
        for i, line in enumerate(text_array):
            y = y0 + i * line_height
            img = cv2.putText(
                img,
                line,
                (x, y),
                font,  # font
                font_scale,  # font scale
                colour,  # colour - BGR
                thickness,  # thickness
                line_type,  # line type
            )

        return img

    def generate_video(self, video_name: str):
        # update the text overlay to include the video name
        self.video_text_overlay = f"{self.video_text_overlay}\nVideo Name: {video_name}"

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
            image = cv2.imread(os.path.join(self.filepath, f"{num}.png"))
            image = self.overlay_text(image)
            video.write(image)

        # add the birds eye view image
        if os.path.exists(self.birds_eye_view_image_path):
            image = cv2.imread(self.birds_eye_view_image_path)
            image = self.overlay_text(image)
            for i in range(5):
                video.write(image)

        # Deallocating memories taken for window creation
        cv2.destroyAllWindows()
        video.release()  # releasing the video generated

        print(f"Video saved to {os.path.join(self.filepath, video_name)}")

    def clean_up(self):
        # delete all the intermediate images
        for i in range(self.image_count):
            os.remove(os.path.join(self.filepath, f"{i}.png"))

        self.image_count = 0

        # delete the birds eye view image
        if os.path.exists(self.birds_eye_view_image_path):
            os.remove(self.birds_eye_view_image_path)
