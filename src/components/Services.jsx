import mockup from "../utils/data.json";
import { Link } from "react-router-dom";

function ServiceList() {
    const data = mockup.services;
    return (
        <div className="flex-3 relative flex xl:overflow-x-hidden overflow-x-scroll">
            {Object.entries(data).map(([key, service]) => (
                <Link
                    to={`services/${key}`}
                    key={key}
                    className="cards rounded-2xl border-2 overflow-clip m-2 min-w-2xs flex flex-col justify-end text-white relative hover:cursor-pointer inset-shadow-sm group transform transition-transform duration-300 hover:shadow-lg"
                >
                    <div
                        className="w-full h-full relative flex flex-col justify-end"
                        style={{
                            backgroundImage: `url(${service.image})`,
                            backgroundColor: "#ffffff",
                            backgroundSize: "cover",
                            backgroundRepeat: "no-repeat",
                            backgroundPosition: "center",
                            filter: "grayscale(30%) brightness(90%) contrast(110%)", // Custom filter effects
                        }}
                    >
                        <h3 className="absolute top-2 left-2 text-xl bg-black opacity-70 p-1 rounded-md text-amber-500 ring-slate-500 shadow-lg shadow-amber-500">
                            {" "}
                            {service.name}{" "}
                        </h3>
                        <p className="bg-black opacity-80 p-2 rounded-md backdrop-blur-md">
                            {" "}
                            {service.description}{" "}
                            <span className="group-hover:text-amber-500 transition-all duration-200">
                                <i className="fa-solid fa-arrow-up-right-from-square"></i>
                            </span>
                        </p>
                    </div>
                </Link>
            ))}
        </div>
    );
}

const Services = () => {
    return (
        <section
            id="work"
            className="h-screen flex flex-col justify-center items-center gap-10 border-t"
        >
            <div className="w-full h-[80%] md:h-[90%] flex flex-col p-2 overflow-clip">
                <div className="flex-1">
                    <h2 className="font-[Boldonse] text-5xl md:text-7xl">
                        Our <span className="text-amber-500">Services</span>
                    </h2>
                </div>
                <ServiceList />
            </div>
        </section>
    );
};

export default Services;
